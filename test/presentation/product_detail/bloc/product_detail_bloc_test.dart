import 'package:bloc_test/bloc_test.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetProductUseCase getProduct;

  /// The same product as the list had it, with newer stock.
  final fresh = testProduct.copyWith(stock: 42);

  setUp(() => getProduct = MockGetProductUseCase());

  ProductDetailBloc buildBloc() => ProductDetailBloc(getProduct);

  void givenProduct(Result<Product> result) =>
      when(() => getProduct(1)).thenAnswer((_) async => result);

  test('starts loading', () {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state, const ProductDetailState.loading());
  });

  blocTest<ProductDetailBloc, ProductDetailState>(
    'loads the product by id',
    setUp: () => givenProduct(const Result.ok(testProduct)),
    build: buildBloc,
    act: (bloc) => bloc.add(const ProductDetailEvent.loadRequested(1)),
    expect: () => const [ProductDetailState.loaded(testProduct)],
    verify: (_) => verify(() => getProduct(1)).called(1),
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'shows the preview at once, then the fresh product',
    setUp: () => givenProduct(Result.ok(fresh)),
    build: buildBloc,
    act: (bloc) => bloc.add(
      const ProductDetailEvent.loadRequested(1, preview: testProduct),
    ),
    expect: () => [
      const ProductDetailState.loaded(testProduct),
      ProductDetailState.loaded(fresh),
    ],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'ignores a preview of another product',
    setUp: () => givenProduct(const Result.ok(testProduct)),
    build: buildBloc,
    act: (bloc) =>
        bloc.add(ProductDetailEvent.loadRequested(1, preview: otherProduct)),
    expect: () => const [ProductDetailState.loaded(testProduct)],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'reports the failure when there is no preview',
    setUp: () => givenProduct(const Result.err(Failure.notFound())),
    build: buildBloc,
    act: (bloc) => bloc.add(const ProductDetailEvent.loadRequested(1)),
    expect: () => const [ProductDetailState.failure(Failure.notFound())],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'keeps the preview when the fetch fails',
    setUp: () => givenProduct(const Result.err(Failure.network())),
    build: buildBloc,
    act: (bloc) => bloc.add(
      const ProductDetailEvent.loadRequested(1, preview: testProduct),
    ),
    expect: () => const [ProductDetailState.loaded(testProduct)],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'shows the spinner again when retrying after a failure',
    setUp: () => givenProduct(const Result.ok(testProduct)),
    build: buildBloc,
    seed: () => const ProductDetailState.failure(Failure.network()),
    act: (bloc) => bloc.add(const ProductDetailEvent.loadRequested(1)),
    expect: () => const [
      ProductDetailState.loading(),
      ProductDetailState.loaded(testProduct),
    ],
  );
}
