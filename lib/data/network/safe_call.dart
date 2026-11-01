import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:dummy_shop/data/network/dio_failure_mapper.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';

/// Runs an API [request] and wraps its outcome in a [Result].
///
/// Repository implementations use this so error handling lives in one place.
/// A [DioException] becomes the matching [Failure]. Any other error, such as a
/// response that does not match its DTO, is logged and becomes
/// [Failure.unknown].
Future<Result<T>> safeCall<T>(Future<T> Function() request) async {
  try {
    return Result.ok(await request());
  } on DioException catch (e) {
    return Result.err(e.toFailure());
  } catch (error, stackTrace) {
    developer.log(
      'Unexpected error during an API call',
      name: 'network',
      error: error,
      stackTrace: stackTrace,
    );
    return Result.err(const Failure.unknown());
  }
}
