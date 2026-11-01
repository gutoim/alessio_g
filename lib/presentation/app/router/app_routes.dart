/// Route locations, for `context.go` and `context.push`.
abstract final class AppRoutes {
  static const String login = '/login';
  static const String products = '/products';

  static String productDetail(int id) => '$products/$id';
}
