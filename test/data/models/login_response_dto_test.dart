import 'dart:convert';

import 'package:dummy_shop/data/models/login_response_dto.dart';
import 'package:dummy_shop/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Same shape as a real `POST /auth/login` response, with fake tokens.
  const responseBody = '''
{
  "id": 1,
  "username": "emilys",
  "email": "emily.johnson@x.dummyjson.com",
  "firstName": "Emily",
  "lastName": "Johnson",
  "gender": "female",
  "image": "https://dummyjson.com/icon/emilys/128",
  "accessToken": "access-token",
  "refreshToken": "refresh-token"
}
''';

  Map<String, dynamic> decode(String body) =>
      jsonDecode(body) as Map<String, dynamic>;

  test('parses the tokens from a login response', () {
    final dto = LoginResponseDto.fromJson(decode(responseBody));

    expect(dto.accessToken, 'access-token');
    expect(dto.refreshToken, 'refresh-token');
  });

  test('maps the profile to a User', () {
    final dto = LoginResponseDto.fromJson(decode(responseBody));

    expect(
      dto.toDomain(),
      const User(
        id: 1,
        username: 'emilys',
        email: 'emily.johnson@x.dummyjson.com',
        firstName: 'Emily',
        lastName: 'Johnson',
        imageUrl: 'https://dummyjson.com/icon/emilys/128',
      ),
    );
  });

  test('accepts a response without an image', () {
    final json = decode(responseBody)..remove('image');

    expect(LoginResponseDto.fromJson(json).toDomain().imageUrl, isNull);
  });
}
