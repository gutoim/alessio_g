import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_dto.g.dart';

/// Response of `POST /auth/refresh`.
@JsonSerializable(createToJson: false)
class RefreshTokenResponseDto {
  const RefreshTokenResponseDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseDtoFromJson(json);

  final String accessToken;
  final String refreshToken;

  /// Tokens are a data-layer concern, so this maps to [AuthTokens], not to a
  /// domain entity.
  AuthTokens toTokens() =>
      (accessToken: accessToken, refreshToken: refreshToken);
}
