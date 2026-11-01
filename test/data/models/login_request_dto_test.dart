import 'package:dummy_shop/data/models/login_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes to the body DummyJSON expects', () {
    const dto = LoginRequestDto(username: 'emilys', password: 'emilyspass');

    expect(dto.toJson(), {'username': 'emilys', 'password': 'emilyspass'});
  });
}
