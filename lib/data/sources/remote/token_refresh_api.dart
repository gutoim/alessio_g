import 'package:dio/dio.dart';
import 'package:dummy_shop/data/models/refresh_token_request_dto.dart';
import 'package:dummy_shop/data/models/refresh_token_response_dto.dart';
import 'package:dummy_shop/data/network/dio_names.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'token_refresh_api.g.dart';

/// `POST /auth/refresh`, on the plain [Dio] so a refresh can never trigger
/// another refresh.
@lazySingleton
@RestApi()
abstract class TokenRefreshApi {
  @factoryMethod
  factory TokenRefreshApi(@Named(DioNames.plain) Dio dio) = _TokenRefreshApi;

  @POST('/auth/refresh')
  Future<RefreshTokenResponseDto> refresh(
    @Body() RefreshTokenRequestDto request,
  );
}
