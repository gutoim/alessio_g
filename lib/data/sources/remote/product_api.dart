import 'package:dio/dio.dart';
import 'package:dummy_shop/data/models/product_dto.dart';
import 'package:dummy_shop/data/models/products_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'product_api.g.dart';

/// DummyJSON product endpoints. Uses the main [Dio], so requests carry the
/// access token and refresh it when needed.
@lazySingleton
@RestApi()
abstract class ProductApi {
  @factoryMethod
  factory ProductApi(Dio dio) = _ProductApi;

  @GET('/products')
  Future<ProductsResponseDto> getProducts({
    @Query('skip') required int skip,
    @Query('limit') required int limit,
  });

  @GET('/products/{id}')
  Future<ProductDto> getProduct(@Path('id') int id);
}
