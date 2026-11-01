import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/auth_interceptor.dart';
import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

/// Records the outgoing request instead of sending it.
class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MockTokenStorage tokenStorage;
  late _RecordingAdapter adapter;
  late Dio dio;

  setUp(() {
    tokenStorage = _MockTokenStorage();
    adapter = _RecordingAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'))
      ..httpClientAdapter = adapter
      ..interceptors.add(AuthInterceptor(tokenStorage));
  });

  Future<Map<String, dynamic>> sentHeaders() async {
    await dio.get<Object?>('/products');
    return adapter.lastRequest!.headers;
  }

  test('adds the access token as a bearer token', () async {
    when(() => tokenStorage.read()).thenAnswer(
      (_) async => (accessToken: 'access-token', refreshToken: 'refresh'),
    );

    expect(
      await sentHeaders(),
      containsPair('Authorization', 'Bearer access-token'),
    );
  });

  test('sends no Authorization header without a session', () async {
    when(() => tokenStorage.read()).thenAnswer((_) async => null);

    expect(await sentHeaders(), isNot(contains('Authorization')));
  });

  test('still sends the request when the token cannot be read', () async {
    when(() => tokenStorage.read()).thenThrow(Exception('Keychain locked'));

    expect(await sentHeaders(), isNot(contains('Authorization')));
  });
}
