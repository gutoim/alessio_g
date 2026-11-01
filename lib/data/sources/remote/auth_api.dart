import 'package:dio/dio.dart';
import 'package:dummy_shop/data/models/login_request_dto.dart';
import 'package:dummy_shop/data/models/login_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

/// DummyJSON auth endpoints. The base URL comes from the injected [Dio].
@lazySingleton
@RestApi()
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);
}
