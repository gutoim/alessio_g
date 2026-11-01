import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/safe_call.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('safeCall', () {
    test('wraps the value of a successful request in Ok', () async {
      final result = await safeCall(() async => 42);

      expect(result, const Result<int>.ok(42));
    });

    test('maps a DioException to Err with the matching failure', () async {
      final result = await safeCall<int>(
        () => throw DioException(
          requestOptions: RequestOptions(path: '/products'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(result, const Result<int>.err(Failure.network()));
    });

    test('maps any other error to Err(unknown)', () async {
      final result = await safeCall<int>(
        () async => throw const FormatException('Unexpected character'),
      );

      expect(result, const Result<int>.err(Failure.unknown()));
    });
  });
}
