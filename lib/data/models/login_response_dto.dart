import 'package:dummy_shop/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

/// Response of `POST /auth/login`: the user profile plus the session tokens.
@JsonSerializable(createToJson: false)
class LoginResponseDto {
  const LoginResponseDto({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.accessToken,
    required this.refreshToken,
    this.image,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String accessToken;
  final String refreshToken;

  /// The tokens stay in the data layer. The domain only sees the [User].
  User toDomain() => User(
    id: id,
    username: username,
    email: email,
    firstName: firstName,
    lastName: lastName,
    imageUrl: image,
  );
}
