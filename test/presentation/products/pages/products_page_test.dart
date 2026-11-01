import 'dart:async';

import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/products/bloc/products_bloc.dart';
import 'package:dummy_shop/presentation/products/bloc/products_event.dart';
import 'package:dummy_shop/presentation/products/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetProductsUseCase getProducts;

  const networkMessage =
      'No internet connection. Check your connection and try again.';

  setUp(() => getProducts = MockGetProductsUseCase());

  /// Answers the use case calls in order with [results].
  void givenResults(List<Result<PaginatedProducts>> results) {
    final queue = [...results];
    when(
      () => anyGetProducts(getProducts),
    ).thenAnswer((_) async => queue.removeAt(0));
  }

  /// The real [ProductsBloc] with a mocked use case, in a router with a
  /// stand-in detail page.
  Future<void> pumpProductsPage(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.products,
      routes: [
        GoRoute(
          path: AppRoutes.products,
          builder: (_, _) => BlocProvider(
            create: (_) =>
                ProductsBloc(getProducts)
                  ..add(const ProductsEvent.loadRequested()),
            child: const ProductsPage(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) =>
                  Text('detail ${state.pathParameters['id']}'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pump();
  }

  Future<void> pullToRefresh(WidgetTester tester, Finder from) async {
    await tester.fling(from, const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
  }

  testWidgets('shows a spinner while the first page loads', (tester) async {
    final pending = Completer<Result<PaginatedProducts>>();
    when(() => anyGetProducts(getProducts)).thenAnswer((_) => pending.future);

    await pumpProductsPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.complete(Result.ok(productsPage([testProduct])));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows each product with brand, price and rating', (
    tester,
  ) async {
    givenResults([
      Result.ok(productsPage([testProduct, otherProduct])),
    ]);

    await pumpProductsPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
    expect(find.text('Essence'), findsOneWidget);
    expect(find.text(r'$8.94'), findsOneWidget); // after the 10.48% discount
    expect(find.text(r'$9.99'), findsOneWidget); // list price, struck through
    expect(find.text('2.6'), findsNWidgets(2));

    // No discount: one price only. No brand: no brand line.
    expect(find.text('Green Chili Pepper'), findsOneWidget);
    expect(find.text(r'$0.99'), findsOneWidget);
  });

  testWidgets('shows the error with a retry that loads again', (tester) async {
    givenResults([
      const Result.err(Failure.network()),
      Result.ok(productsPage([testProduct])),
    ]);

    await pumpProductsPage(tester);
    await tester.pumpAndSettle();
    expect(find.text(networkMessage), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text(networkMessage), findsNothing);
    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no products', (
    tester,
  ) async {
    givenResults([Result.ok(productsPage([], total: 0))]);

    await pumpProductsPage(tester);
    await tester.pumpAndSettle();

    expect(find.text('No products yet'), findsOneWidget);
  });

  testWidgets('pull-to-refresh replaces the list', (tester) async {
    givenResults([
      Result.ok(productsPage([testProduct])),
      Result.ok(productsPage([otherProduct])),
    ]);
    await pumpProductsPage(tester);
    await tester.pumpAndSettle();

    await pullToRefresh(tester, find.text('Essence Mascara Lash Princess'));

    expect(find.text('Green Chili Pepper'), findsOneWidget);
    expect(find.text('Essence Mascara Lash Princess'), findsNothing);
  });

  testWidgets('pull-to-refresh also works on the empty state', (tester) async {
    givenResults([
      Result.ok(productsPage([], total: 0)),
      Result.ok(productsPage([testProduct])),
    ]);
    await pumpProductsPage(tester);
    await tester.pumpAndSettle();

    await pullToRefresh(tester, find.text('No products yet'));

    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
  });

  testWidgets('a failed refresh keeps the list and shows a snackbar', (
    tester,
  ) async {
    givenResults([
      Result.ok(productsPage([testProduct])),
      const Result.err(Failure.network()),
    ]);
    await pumpProductsPage(tester);
    await tester.pumpAndSettle();

    await pullToRefresh(tester, find.text('Essence Mascara Lash Princess'));

    expect(find.widgetWithText(SnackBar, networkMessage), findsOneWidget);
    expect(find.text('Essence Mascara Lash Princess'), findsOneWidget);
  });

  testWidgets('tapping a product opens its detail page', (tester) async {
    givenResults([
      Result.ok(productsPage([testProduct])),
    ]);
    await pumpProductsPage(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Essence Mascara Lash Princess'));
    await tester.pumpAndSettle();

    expect(find.text('detail 1'), findsOneWidget);
  });

  group('pagination', () {
    void givenPage(int skip, List<Result<PaginatedProducts>> results) {
      final queue = [...results];
      when(
        () => getProducts(skip: skip),
      ).thenAnswer((_) async => queue.removeAt(0));
    }

    Future<void> scrollToEnd(WidgetTester tester) async {
      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();
    }

    testWidgets('loads the next page when scrolling near the end', (
      tester,
    ) async {
      givenPage(0, [
        Result.ok(productsPage(numberedProducts(1, 20), total: 40)),
      ]);
      givenPage(20, [
        Result.ok(productsPage(numberedProducts(21, 20), skip: 20, total: 40)),
      ]);
      await pumpProductsPage(tester);
      await tester.pumpAndSettle();
      verifyNever(() => getProducts(skip: 20));

      await scrollToEnd(tester);
      await scrollToEnd(tester);

      verify(() => getProducts(skip: 20)).called(1);
      expect(find.text('Product 40'), findsOneWidget);
      expect(find.text("That's all 40 products"), findsOneWidget);
    });

    testWidgets('shows a spinner under the list while the page loads', (
      tester,
    ) async {
      final pendingPage = Completer<Result<PaginatedProducts>>();
      givenPage(0, [
        Result.ok(productsPage(numberedProducts(1, 20), total: 40)),
      ]);
      when(() => getProducts(skip: 20)).thenAnswer((_) => pendingPage.future);
      await pumpProductsPage(tester);
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pendingPage.complete(
        Result.ok(productsPage(numberedProducts(21, 20), skip: 20, total: 40)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows the error under the list and only the button retries', (
      tester,
    ) async {
      givenPage(0, [
        Result.ok(productsPage(numberedProducts(1, 20), total: 40)),
      ]);
      givenPage(20, [
        const Result.err(Failure.network()),
        Result.ok(productsPage(numberedProducts(21, 20), skip: 20, total: 40)),
      ]);
      await pumpProductsPage(tester);
      await tester.pumpAndSettle();

      await scrollToEnd(tester);
      expect(find.text(networkMessage), findsOneWidget);

      // Scrolling away and back does not send another request.
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      await tester.pumpAndSettle();
      await scrollToEnd(tester);
      verify(() => getProducts(skip: 20)).called(1);

      await tester.tap(find.widgetWithText(TextButton, 'Try again'));
      await tester.pumpAndSettle();
      await scrollToEnd(tester);

      verify(() => getProducts(skip: 20)).called(1);
      expect(find.text(networkMessage), findsNothing);
      expect(find.text('Product 40'), findsOneWidget);
    });

    testWidgets('marks the end of a list that fits on one page', (
      tester,
    ) async {
      givenPage(0, [Result.ok(productsPage(numberedProducts(1, 3), total: 3))]);

      await pumpProductsPage(tester);
      await tester.pumpAndSettle();

      expect(find.text("That's all 3 products"), findsOneWidget);
      verifyNever(() => getProducts(skip: 3));
    });

    testWidgets('loads more right away when a page does not fill the screen', (
      tester,
    ) async {
      givenPage(0, [Result.ok(productsPage(numberedProducts(1, 3), total: 6))]);
      givenPage(3, [
        Result.ok(productsPage(numberedProducts(4, 3), skip: 3, total: 6)),
      ]);

      await pumpProductsPage(tester);
      await tester.pumpAndSettle();

      // Requested without any scrolling.
      verify(() => getProducts(skip: 3)).called(1);

      await scrollToEnd(tester);
      expect(find.text('Product 6'), findsOneWidget);
      expect(find.text("That's all 6 products"), findsOneWidget);
    });
  });
}
