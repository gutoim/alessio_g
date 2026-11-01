import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/presentation/products/bloc/products_bloc.dart';
import 'package:dummy_shop/presentation/products/bloc/products_event.dart';
import 'package:dummy_shop/presentation/products/bloc/products_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetProductsUseCase getProducts;

  const loaded = ProductsState.loaded(products: [testProduct], hasMore: true);

  setUp(() => getProducts = MockGetProductsUseCase());

  ProductsBloc buildBloc() => ProductsBloc(getProducts);

  test('starts loading', () {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state, const ProductsState.loading());
  });

  group('loadRequested', () {
    blocTest<ProductsBloc, ProductsState>(
      'loads the first page',
      setUp: () => when(() => anyGetProducts(getProducts)).thenAnswer(
        (_) async => Result.ok(productsPage([testProduct], total: 194)),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const ProductsEvent.loadRequested()),
      expect: () => [loaded],
      verify: (_) => verify(() => getProducts(skip: 0)).called(1),
    );

    blocTest<ProductsBloc, ProductsState>(
      'shows the empty state when there are no products',
      setUp: () => when(
        () => anyGetProducts(getProducts),
      ).thenAnswer((_) async => Result.ok(productsPage([], total: 0))),
      build: buildBloc,
      act: (bloc) => bloc.add(const ProductsEvent.loadRequested()),
      expect: () => const [ProductsState.loaded(products: [], hasMore: false)],
    );

    blocTest<ProductsBloc, ProductsState>(
      'reports a failure of the first page',
      setUp: () => when(
        () => anyGetProducts(getProducts),
      ).thenAnswer((_) async => const Result.err(Failure.network())),
      build: buildBloc,
      act: (bloc) => bloc.add(const ProductsEvent.loadRequested()),
      expect: () => const [ProductsState.failure(Failure.network())],
    );

    blocTest<ProductsBloc, ProductsState>(
      'shows the spinner again when retrying after a failure',
      setUp: () => when(() => anyGetProducts(getProducts)).thenAnswer(
        (_) async => Result.ok(productsPage([testProduct], total: 194)),
      ),
      build: buildBloc,
      seed: () => const ProductsState.failure(Failure.network()),
      act: (bloc) => bloc.add(const ProductsEvent.loadRequested()),
      expect: () => [const ProductsState.loading(), loaded],
    );
  });

  group('refreshRequested', () {
    blocTest<ProductsBloc, ProductsState>(
      'keeps the list visible while refreshing, then replaces it',
      setUp: () => when(() => anyGetProducts(getProducts)).thenAnswer(
        (_) async => Result.ok(productsPage([otherProduct], total: 194)),
      ),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const ProductsEvent.refreshRequested()),
      expect: () => [
        const ProductsState.loaded(
          products: [testProduct],
          hasMore: true,
          isRefreshing: true,
        ),
        ProductsState.loaded(products: [otherProduct], hasMore: true),
      ],
      verify: (_) => verify(() => getProducts(skip: 0)).called(1),
    );

    blocTest<ProductsBloc, ProductsState>(
      'keeps the list and reports the failure when the refresh fails',
      setUp: () => when(
        () => anyGetProducts(getProducts),
      ).thenAnswer((_) async => const Result.err(Failure.network())),
      build: buildBloc,
      seed: () => loaded,
      act: (bloc) => bloc.add(const ProductsEvent.refreshRequested()),
      expect: () => [
        const ProductsState.loaded(
          products: [testProduct],
          hasMore: true,
          isRefreshing: true,
        ),
        const ProductsState.loaded(
          products: [testProduct],
          hasMore: true,
          refreshFailure: Failure.network(),
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'clears the previous refresh failure when refreshing again',
      setUp: () => when(() => anyGetProducts(getProducts)).thenAnswer(
        (_) async => Result.ok(productsPage([testProduct], total: 194)),
      ),
      build: buildBloc,
      seed: () => const ProductsState.loaded(
        products: [testProduct],
        hasMore: true,
        refreshFailure: Failure.network(),
      ),
      act: (bloc) => bloc.add(const ProductsEvent.refreshRequested()),
      expect: () => [
        const ProductsState.loaded(
          products: [testProduct],
          hasMore: true,
          isRefreshing: true,
        ),
        loaded,
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'is ignored while the first page is loading',
      build: buildBloc,
      act: (bloc) => bloc.add(const ProductsEvent.refreshRequested()),
      expect: () => const <ProductsState>[],
      verify: (_) => verifyNever(() => anyGetProducts(getProducts)),
    );
  });

  group('nextPageRequested', () {
    final firstPage = numberedProducts(1, 20);
    final secondPage = numberedProducts(21, 20);
    final onFirstPage = ProductsLoaded(products: firstPage, hasMore: true);

    void givenNextPage(Future<Result<PaginatedProducts>> Function() answer) =>
        when(() => getProducts(skip: 20)).thenAnswer((_) => answer());

    blocTest<ProductsBloc, ProductsState>(
      'appends the page that follows the loaded products',
      setUp: () => givenNextPage(
        () async => Result.ok(productsPage(secondPage, skip: 20, total: 60)),
      ),
      build: buildBloc,
      seed: () => onFirstPage,
      act: (bloc) => bloc.add(const ProductsEvent.nextPageRequested()),
      expect: () => [
        onFirstPage.copyWith(isLoadingMore: true),
        ProductsState.loaded(
          products: [...firstPage, ...secondPage],
          hasMore: true,
        ),
      ],
      verify: (_) => verify(() => getProducts(skip: 20)).called(1),
    );

    blocTest<ProductsBloc, ProductsState>(
      'marks the end of the list after the last page',
      setUp: () => givenNextPage(
        () async => Result.ok(productsPage(secondPage, skip: 20, total: 40)),
      ),
      build: buildBloc,
      seed: () => onFirstPage,
      act: (bloc) => bloc.add(const ProductsEvent.nextPageRequested()),
      expect: () => [
        onFirstPage.copyWith(isLoadingMore: true),
        ProductsState.loaded(
          products: [...firstPage, ...secondPage],
          hasMore: false,
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'keeps the products and reports the failure when the page fails',
      setUp: () =>
          givenNextPage(() async => const Result.err(Failure.network())),
      build: buildBloc,
      seed: () => onFirstPage,
      act: (bloc) => bloc.add(const ProductsEvent.nextPageRequested()),
      expect: () => [
        onFirstPage.copyWith(isLoadingMore: true),
        onFirstPage.copyWith(loadMoreFailure: const Failure.network()),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'retries after a failure',
      setUp: () => givenNextPage(
        () async => Result.ok(productsPage(secondPage, skip: 20, total: 60)),
      ),
      build: buildBloc,
      seed: () =>
          onFirstPage.copyWith(loadMoreFailure: const Failure.network()),
      act: (bloc) => bloc.add(const ProductsEvent.nextPageRequested()),
      expect: () => [
        onFirstPage.copyWith(isLoadingMore: true),
        ProductsState.loaded(
          products: [...firstPage, ...secondPage],
          hasMore: true,
        ),
      ],
    );

    for (final (reason, seed) in [
      ('the whole list is loaded', onFirstPage.copyWith(hasMore: false)),
      (
        'a pull-to-refresh is running',
        onFirstPage.copyWith(isRefreshing: true),
      ),
      (
        'the next page is already loading',
        onFirstPage.copyWith(isLoadingMore: true),
      ),
      ('the first page has not loaded yet', const ProductsState.loading()),
    ]) {
      blocTest<ProductsBloc, ProductsState>(
        'is ignored when $reason',
        build: buildBloc,
        seed: () => seed,
        act: (bloc) => bloc.add(const ProductsEvent.nextPageRequested()),
        expect: () => const <ProductsState>[],
        verify: (_) => verifyNever(() => anyGetProducts(getProducts)),
      );
    }

    final pendingPage = Completer<Result<PaginatedProducts>>();
    blocTest<ProductsBloc, ProductsState>(
      'requests one page at a time while scrolling fires repeatedly',
      setUp: () => givenNextPage(() => pendingPage.future),
      build: buildBloc,
      seed: () => onFirstPage,
      act: (bloc) async {
        bloc
          ..add(const ProductsEvent.nextPageRequested())
          ..add(const ProductsEvent.nextPageRequested())
          ..add(const ProductsEvent.nextPageRequested());
        await Future<void>.delayed(Duration.zero);
        pendingPage.complete(
          Result.ok(productsPage(secondPage, skip: 20, total: 60)),
        );
      },
      skip: 1,
      expect: () => [
        ProductsState.loaded(
          products: [...firstPage, ...secondPage],
          hasMore: true,
        ),
      ],
      verify: (_) => verify(() => anyGetProducts(getProducts)).called(1),
    );

    final staleNextPage = Completer<Result<PaginatedProducts>>();
    final refreshedPage = numberedProducts(101, 20);
    blocTest<ProductsBloc, ProductsState>(
      'drops a page that arrives after a refresh replaced the list',
      setUp: () {
        givenNextPage(() => staleNextPage.future);
        when(() => getProducts(skip: 0)).thenAnswer(
          (_) async => Result.ok(productsPage(refreshedPage, total: 60)),
        );
      },
      build: buildBloc,
      seed: () => onFirstPage,
      act: (bloc) async {
        bloc.add(const ProductsEvent.nextPageRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ProductsEvent.refreshRequested());
        await Future<void>.delayed(Duration.zero);
        staleNextPage.complete(
          Result.ok(productsPage(secondPage, skip: 20, total: 60)),
        );
      },
      expect: () => [
        onFirstPage.copyWith(isLoadingMore: true),
        onFirstPage.copyWith(isRefreshing: true),
        ProductsState.loaded(products: refreshedPage, hasMore: true),
      ],
    );

    final orphanedNextPage = Completer<Result<PaginatedProducts>>();
    blocTest<ProductsBloc, ProductsState>(
      'stops the bottom spinner when a refresh fails during loading more',
      setUp: () {
        givenNextPage(() => orphanedNextPage.future);
        when(
          () => getProducts(skip: 0),
        ).thenAnswer((_) async => const Result.err(Failure.network()));
      },
      build: buildBloc,
      seed: () => onFirstPage,
      act: (bloc) async {
        bloc.add(const ProductsEvent.nextPageRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ProductsEvent.refreshRequested());
        await Future<void>.delayed(Duration.zero);
        orphanedNextPage.complete(
          Result.ok(productsPage(secondPage, skip: 20, total: 60)),
        );
      },
      expect: () => [
        onFirstPage.copyWith(isLoadingMore: true),
        onFirstPage.copyWith(isRefreshing: true),
        onFirstPage.copyWith(refreshFailure: const Failure.network()),
      ],
    );
  });
}
