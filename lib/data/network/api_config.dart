/// DummyJSON API settings.
///
/// The base URL can be overridden at build time:
/// `flutter run --dart-define=BASE_URL=https://example.com`
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
