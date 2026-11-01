import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tokens = (accessToken: 'access-token', refreshToken: 'refresh-token');

  late TokenStorage storage;

  void givenStoredValues(Map<String, String> values) {
    FlutterSecureStorage.setMockInitialValues(values);
    storage = const TokenStorage(FlutterSecureStorage());
  }

  setUp(() => givenStoredValues({}));

  test('returns null when nothing is stored', () async {
    expect(await storage.read(), isNull);
  });

  test('reads back the saved tokens', () async {
    await storage.save(tokens);

    expect(await storage.read(), tokens);
  });

  test('returns null when only one of the tokens is stored', () async {
    // The keys are part of the on-device format: renaming them logs users out.
    givenStoredValues({'auth.access_token': 'access-token'});

    expect(await storage.read(), isNull);
  });

  test('clear removes the tokens', () async {
    await storage.save(tokens);

    await storage.clear();

    expect(await storage.read(), isNull);
  });
}
