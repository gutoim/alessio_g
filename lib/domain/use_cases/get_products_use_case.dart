import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/domain/repositories/product_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  static const int defaultPageSize = 20;

  final ProductRepository _repository;

  Future<Result<PaginatedProducts>> call({
    required int skip,
    int limit = defaultPageSize,
  }) => _repository.getProducts(skip: skip, limit: limit);
}
