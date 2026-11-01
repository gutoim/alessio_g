import 'package:dio/dio.dart';
import 'package:dummy_shop/data/models/product_dto.dart';
import 'package:dummy_shop/data/models/products_response_dto.dart';
import 'package:dummy_shop/data/repositories/product_repository_impl.dart';
import 'package:dummy_shop/data/sources/remote/product_api.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';

class _MockProductApi extends Mock implements ProductApi {}

void main() {
  late _MockProductApi api;
  late ProductRepositoryImpl repository;

  setUp(() {
    api = _MockProductApi();
    repository = ProductRepositoryImpl(api);
  });

  DioException httpError(String path, int statusCode) {
    final requestOptions = RequestOptions(path: path);
    return DioException(
      requestOptions: requestOptions,
      type: DioExceptionType.badResponse,
      response: Response<Object?>(
        requestOptions: requestOptions,
        statusCode: statusCode,
      ),
    );
  }

  group('getProducts', () {
    test('requests the page and maps it', () async {
      when(() => api.getProducts(skip: 0, limit: 2)).thenAnswer(
        (_) async => ProductsResponseDto.fromJson(jsonFixture('products_page')),
      );

      final result = await repository.getProducts(skip: 0, limit: 2);

      expect(
        result,
        isA<Ok<PaginatedProducts>>()
            .having((ok) => ok.value.items.first, 'first item', testProduct)
            .having((ok) => ok.value.total, 'total', 194),
      );
    });

    test('maps a network error to a failure', () async {
      when(() => api.getProducts(skip: 20, limit: 20)).thenThrow(
        DioException.connectionError(
          requestOptions: RequestOptions(path: '/products'),
          reason: 'offline',
        ),
      );

      expect(
        await repository.getProducts(skip: 20, limit: 20),
        const Result<PaginatedProducts>.err(Failure.network()),
      );
    });
  });

  group('getProduct', () {
    test('requests the product by id and maps it', () async {
      when(
        () => api.getProduct(1),
      ).thenAnswer((_) async => ProductDto.fromJson(jsonFixture('product')));

      expect(await repository.getProduct(1), const Result.ok(testProduct));
    });

    test('maps a 404 to notFound', () async {
      when(
        () => api.getProduct(99999),
      ).thenThrow(httpError('/products/99999', 404));

      expect(
        await repository.getProduct(99999),
        const Result<Product>.err(Failure.notFound()),
      );
    });
  });
}
