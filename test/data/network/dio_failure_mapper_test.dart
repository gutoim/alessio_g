import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/dio_failure_mapper.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestOptions = RequestOptions(path: '/products');

  DioException exceptionOf(DioExceptionType type, {Object? error}) =>
      DioException(requestOptions: requestOptions, type: type, error: error);

  DioException badResponse(int statusCode, {Object? body}) => DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: body,
    ),
  );

  group('DioException.toFailure', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.transformTimeout,
      DioExceptionType.connectionError,
      DioExceptionType.badCertificate,
    ]) {
      test('maps ${type.name} to network', () {
        expect(exceptionOf(type).toFailure(), const Failure.network());
      });
    }

    test('maps an unknown error caused by a socket error to network', () {
      final exception = exceptionOf(
        DioExceptionType.unknown,
        error: const SocketException('Failed host lookup'),
      );

      expect(exception.toFailure(), const Failure.network());
    });

    test('maps any other unknown error to unknown', () {
      final exception = exceptionOf(
        DioExceptionType.unknown,
        error: const FormatException('Unexpected character'),
      );

      expect(exception.toFailure(), const Failure.unknown());
    });

    test('maps a cancelled request to unknown', () {
      expect(
        exceptionOf(DioExceptionType.cancel).toFailure(),
        const Failure.unknown(),
      );
    });

    test('maps 401 to unauthorized', () {
      final exception = badResponse(
        401,
        body: {'message': 'Invalid/Expired Token!'},
      );

      expect(exception.toFailure(), const Failure.unauthorized());
    });

    test('maps 404 to notFound', () {
      final exception = badResponse(
        404,
        body: {'message': "Product with id '99999' not found"},
      );

      expect(exception.toFailure(), const Failure.notFound());
    });

    test('maps other status codes to server, keeping the API message', () {
      final exception = badResponse(
        400,
        body: {'message': 'Invalid credentials'},
      );

      expect(
        exception.toFailure(),
        const Failure.server(statusCode: 400, message: 'Invalid credentials'),
      );
    });

    test('maps a response body without a message to server', () {
      final exception = badResponse(502, body: '<html>Bad Gateway</html>');

      expect(exception.toFailure(), const Failure.server(statusCode: 502));
    });
  });
}
