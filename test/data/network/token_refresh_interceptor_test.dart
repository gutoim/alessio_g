import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/auth_interceptor.dart';
import 'package:dummy_shop/data/network/token_refresh_interceptor.dart';
import 'package:dummy_shop/data/sources/local/auth_status_source.dart';
import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:dummy_shop/data/sources/remote/token_refresh_api.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

typedef _Handler = FutureOr<ResponseBody> Function(RequestOptions request);

/// Answers every request with [handler] and records it.
class _FakeServer implements HttpClientAdapter {
  _FakeServer(this.handler);

  _Handler handler;
  final List<RequestOptions> requests = [];

  int callsTo(String path) => requests.where((r) => r.path == path).length;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int statusCode, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  statusCode,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  const expired = (accessToken: 'old-access', refreshToken: 'refresh-token');
  const refreshed = (accessToken: 'new-access', refreshToken: 'refresh-2');

  late _FakeServer server;
  late TokenStorage storage;
  late AuthStatusSource authStatus;
  late Dio dio;

  /// Stand-in for DummyJSON: data endpoints accept only the refreshed access
  /// token, and `/auth/refresh` accepts only the stored refresh token.
  ResponseBody dummyJson(RequestOptions request) {
    if (request.path == '/auth/refresh') {
      final body = request.data as Map<String, dynamic>;
      return body['refreshToken'] == expired.refreshToken
          ? _json(200, {
              'accessToken': refreshed.accessToken,
              'refreshToken': refreshed.refreshToken,
            })
          : _json(403, {'message': 'Invalid refresh token'});
    }
    return request.headers['Authorization'] == 'Bearer ${refreshed.accessToken}'
        ? _json(200, {'products': <Object>[]})
        : _json(401, {'message': 'Token Expired!'});
  }

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    storage = const TokenStorage(FlutterSecureStorage());
    await storage.save(expired);
    authStatus = AuthStatusSource();
    server = _FakeServer(dummyJson);

    final plainDio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'))
      ..httpClientAdapter = server;
    dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'))
      ..httpClientAdapter = server
      ..interceptors.addAll([
        AuthInterceptor(storage),
        TokenRefreshInterceptor(
          storage,
          TokenRefreshApi(plainDio),
          authStatus,
          plainDio,
        ),
      ]);
  });

  tearDown(() => authStatus.dispose());

  /// The status code the caller finally sees, whether it succeeded or not.
  Future<int?> statusCodeOf(String path) async {
    try {
      return (await dio.get<Object?>(path)).statusCode;
    } on DioException catch (error) {
      return error.response?.statusCode;
    }
  }

  /// Collects the auth status changes sent while [action] runs.
  Future<List<AuthStatus>> statusChangesDuring(
    Future<void> Function() action,
  ) async {
    final changes = <AuthStatus>[];
    final subscription = authStatus.changes.listen(changes.add);
    await action();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    return changes;
  }

  test('refreshes the access token on a 401 and retries the request', () async {
    expect(await statusCodeOf('/products'), 200);

    expect(server.requests.map((r) => r.path), [
      '/products',
      '/auth/refresh',
      '/products',
    ]);
    expect(await storage.read(), refreshed);
  });

  test('refreshes only once when several requests fail together', () async {
    final statusCodes = await Future.wait([
      statusCodeOf('/products'),
      statusCodeOf('/products/1'),
      statusCodeOf('/products/2'),
    ]);

    expect(statusCodes, [200, 200, 200]);
    expect(server.callsTo('/auth/refresh'), 1);
  });

  test('ends the session when the refresh token is rejected', () async {
    await storage.save((accessToken: 'old-access', refreshToken: 'revoked'));

    final changes = await statusChangesDuring(() async {
      expect(await statusCodeOf('/products'), 401);
    });

    expect(changes, [AuthStatus.unauthenticated]);
    expect(await storage.read(), isNull);
  });

  for (final (reason, refreshFailure) in [
    (
      'the server cannot be reached',
      (RequestOptions request) => throw DioException.connectionError(
        requestOptions: request,
        reason: 'offline',
      ),
    ),
    (
      'the refresh endpoint fails',
      (RequestOptions request) => _json(500, {'message': 'Server error'}),
    ),
  ]) {
    test('keeps the session when $reason during the refresh', () async {
      server.handler = (request) => request.path == '/auth/refresh'
          ? refreshFailure(request)
          : dummyJson(request);

      final changes = await statusChangesDuring(() async {
        expect(await statusCodeOf('/products'), 401);
      });

      expect(changes, isEmpty);
      expect(await storage.read(), expired);
    });
  }

  test('retries a request only once', () async {
    server.handler = (request) => request.path == '/auth/refresh'
        ? dummyJson(request)
        : _json(401, {'message': 'Token Expired!'});

    expect(await statusCodeOf('/products'), 401);

    expect(server.callsTo('/products'), 2);
    expect(server.callsTo('/auth/refresh'), 1);
  });

  test('passes other errors through without refreshing', () async {
    server.handler = (request) => _json(500, {'message': 'Server error'});

    expect(await statusCodeOf('/products'), 500);
    expect(server.callsTo('/auth/refresh'), 0);
  });

  test('passes a 401 through when there is no session', () async {
    await storage.clear();

    final changes = await statusChangesDuring(() async {
      expect(await statusCodeOf('/products'), 401);
    });

    expect(server.callsTo('/auth/refresh'), 0);
    expect(changes, isEmpty);
  });
}
