import 'package:dummy_shop/data/network/safe_call.dart';
import 'package:dummy_shop/data/sources/remote/product_api.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/domain/repositories/product_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._api);

  final ProductApi _api;

  // Mapping runs inside `safeCall` too, so an unexpected response shape
  // becomes `Failure.unknown` instead of a crash.
  @override
  Future<Result<PaginatedProducts>> getProducts({
    required int skip,
    required int limit,
  }) => safeCall(
    () async => (await _api.getProducts(skip: skip, limit: limit)).toDomain(),
  );

  @override
  Future<Result<Product>> getProduct(int id) =>
      safeCall(() async => (await _api.getProduct(id)).toDomain());
}
