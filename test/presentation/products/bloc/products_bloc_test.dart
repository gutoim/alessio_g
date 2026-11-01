import 'package:bloc_test/bloc_test.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
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
      setUp: () => when(
        () => anyGetProducts(getProducts),
      ).thenAnswer((_) async => Result.ok(productsPage([testProduct]))),
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
      setUp: () => when(
        () => anyGetProducts(getProducts),
      ).thenAnswer((_) async => Result.ok(productsPage([testProduct]))),
      build: buildBloc,
      seed: () => const ProductsState.failure(Failure.network()),
      act: (bloc) => bloc.add(const ProductsEvent.loadRequested()),
      expect: () => [const ProductsState.loading(), loaded],
    );
  });

  group('refreshRequested', () {
    blocTest<ProductsBloc, ProductsState>(
      'keeps the list visible while refreshing, then replaces it',
      setUp: () => when(
        () => anyGetProducts(getProducts),
      ).thenAnswer((_) async => Result.ok(productsPage([otherProduct]))),
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
      setUp: () => when(
        () => anyGetProducts(getProducts),
      ).thenAnswer((_) async => Result.ok(productsPage([testProduct]))),
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
}
