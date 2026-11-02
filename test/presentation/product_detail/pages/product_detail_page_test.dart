import 'dart:async';

import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:dummy_shop/presentation/product_detail/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetProductUseCase getProduct;

  setUp(() => getProduct = MockGetProductUseCase());

  void givenResults(List<Result<Product>> results) {
    final queue = [...results];
    when(() => getProduct(any())).thenAnswer((_) async => queue.removeAt(0));
  }

  /// The real [ProductDetailBloc] with a mocked use case, on a screen tall
  /// enough to build the whole page.
  Future<void> pumpDetailPage(WidgetTester tester, {Product? preview}) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) =>
              ProductDetailBloc(getProduct, preview: preview)
                ..add(const ProductDetailEvent.loadRequested(1)),
          child: const ProductDetailPage(productId: 1),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows a spinner while loading without a preview', (
    tester,
  ) async {
    final pending = Completer<Result<Product>>();
    when(() => getProduct(1)).thenAnswer((_) => pending.future);

    await pumpDetailPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.complete(const Result.ok(testProduct));
    await tester.pumpAndSettle();
    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
  });

  testWidgets('shows the preview at once, without a spinner', (tester) async {
    final pending = Completer<Result<Product>>();
    when(() => getProduct(1)).thenAnswer((_) => pending.future);

    await pumpDetailPage(tester, preview: testProduct);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);

    pending.complete(const Result.ok(testProduct));
    await tester.pumpAndSettle();
  });

  testWidgets('shows every detail of the product', (tester) async {
    givenResults([const Result.ok(testProduct)]);

    await pumpDetailPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Essence'), findsOneWidget);
    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
    expect(find.text('2.6'), findsOneWidget);
    expect(find.text('In stock'), findsOneWidget);
    expect(find.text(r'$8.94'), findsOneWidget);
    expect(find.text(r'$9.99'), findsOneWidget);
    expect(find.text('-10%'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text(testProduct.description), findsOneWidget);
    expect(find.text('Beauty'), findsOneWidget);
  });

  testWidgets('leaves out the brand and the badge when there are none', (
    tester,
  ) async {
    givenResults([Result.ok(otherProduct)]);

    await pumpDetailPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Essence'), findsNothing);
    expect(find.textContaining('%'), findsNothing);
    expect(find.text('Groceries'), findsOneWidget);
  });

  testWidgets('shows how many items are left when stock is low', (
    tester,
  ) async {
    givenResults([
      Result.ok(
        testProduct.copyWith(stock: 3, stockStatus: StockStatus.lowStock),
      ),
    ]);

    await pumpDetailPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Only 3 left'), findsOneWidget);
  });

  testWidgets('shows when the product is out of stock', (tester) async {
    givenResults([
      Result.ok(
        testProduct.copyWith(stock: 0, stockStatus: StockStatus.outOfStock),
      ),
    ]);

    await pumpDetailPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Out of stock'), findsOneWidget);
  });

  testWidgets('shows the error with a retry that loads again', (tester) async {
    givenResults([
      const Result.err(Failure.notFound()),
      const Result.ok(testProduct),
    ]);

    await pumpDetailPage(tester);
    await tester.pumpAndSettle();
    expect(
      find.text("We couldn't find what you were looking for."),
      findsOneWidget,
    );

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
  });

  group('gallery', () {
    final threeImages = testProduct.copyWith(
      imageUrls: [
        'https://cdn.dummyjson.com/1.webp',
        'https://cdn.dummyjson.com/2.webp',
        'https://cdn.dummyjson.com/3.webp',
      ],
    );

    testWidgets('shows which image is visible and follows swipes', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      givenResults([Result.ok(threeImages)]);

      await pumpDetailPage(tester);
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Image 1 of 3'), findsOneWidget);

      // A short fling moves exactly one page (the gallery is 420 px wide).
      await tester.fling(find.byType(PageView), const Offset(-200, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Image 2 of 3'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('has no indicator for a single image', (tester) async {
      final semantics = tester.ensureSemantics();
      givenResults([const Result.ok(testProduct)]);

      await pumpDetailPage(tester);
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(RegExp('^Image')), findsNothing);
      semantics.dispose();
    });
  });
}
