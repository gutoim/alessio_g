import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dummy_shop/domain/core/failure.dart';

/// Converts a [DioException] into the domain [Failure] it represents.
///
/// The switch has no wildcard on purpose: if Dio adds an exception type,
/// this stops compiling instead of silently mapping it to the wrong case.
extension DioExceptionToFailure on DioException {
  Failure toFailure() => switch (type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError ||
    DioExceptionType.badCertificate => const Failure.network(),
    DioExceptionType.badResponse => _fromResponse(response),
    DioExceptionType.cancel => const Failure.unknown(),
    // Some platforms report a lost connection as `unknown` with a socket error.
    DioExceptionType.unknown =>
      error is SocketException
          ? const Failure.network()
          : const Failure.unknown(),
  };
}

Failure _fromResponse(Response<dynamic>? response) {
  final statusCode = response?.statusCode;
  return switch (statusCode) {
    401 => const Failure.unauthorized(),
    404 => const Failure.notFound(),
    _ => Failure.server(
      statusCode: statusCode,
      message: _apiMessage(response?.data),
    ),
  };
}

/// DummyJSON error bodies look like `{"message": "Invalid credentials"}`.
String? _apiMessage(Object? body) => switch (body) {
  {'message': final String message} => message,
  _ => null,
};
