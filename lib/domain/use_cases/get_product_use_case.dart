import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/domain/repositories/product_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductUseCase {
  const GetProductUseCase(this._repository);

  final ProductRepository _repository;

  Future<Result<Product>> call(int id) => _repository.getProduct(id);
}
