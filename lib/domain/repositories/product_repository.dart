import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/domain/entities/product.dart';

abstract interface class ProductRepository {
  /// Up to [limit] products, starting after the first [skip].
  Future<Result<PaginatedProducts>> getProducts({
    required int skip,
    required int limit,
  });

  /// Fails with `Failure.notFound` when no product has this [id].
  Future<Result<Product>> getProduct(int id);
}
