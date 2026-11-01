import 'dart:convert';

import 'package:dummy_shop/data/models/refresh_token_request_dto.dart';
import 'package:dummy_shop/data/models/refresh_token_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the request serializes to the body DummyJSON expects', () {
    const dto = RefreshTokenRequestDto(refreshToken: 'refresh-token');

    expect(dto.toJson(), {'refreshToken': 'refresh-token'});
  });

  test('the response maps to the stored tokens', () {
    final dto = RefreshTokenResponseDto.fromJson(
      jsonDecode('{"accessToken": "access", "refreshToken": "refresh"}')
          as Map<String, dynamic>,
    );

    expect(dto.toTokens(), (accessToken: 'access', refreshToken: 'refresh'));
  });
}
