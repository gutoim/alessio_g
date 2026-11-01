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
}
