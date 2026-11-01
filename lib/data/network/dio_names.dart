/// Names of the `Dio` instances registered in DI.
abstract final class DioNames {
  /// Same base URL and timeouts as the main client, but no auth or token
  /// refresh interceptors. Used to refresh tokens and to retry the original
  /// request, so neither can trigger another refresh.
  static const String plain = 'plainDio';
}
