import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

/// Body of `POST /auth/login`.
@JsonSerializable(createFactory: false)
class LoginRequestDto {
  const LoginRequestDto({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
