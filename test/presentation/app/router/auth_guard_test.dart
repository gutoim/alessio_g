import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/app/router/auth_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final detail = AppRoutes.productDetail(42);

  final cases = <(AuthStatus, String, String?)>[
    (AuthStatus.unknown, AppRoutes.splash, null),
    (AuthStatus.unknown, AppRoutes.login, AppRoutes.splash),
    (AuthStatus.unknown, detail, AppRoutes.splash),
    (AuthStatus.unauthenticated, AppRoutes.splash, AppRoutes.login),
    (AuthStatus.unauthenticated, AppRoutes.login, null),
    (AuthStatus.unauthenticated, AppRoutes.products, AppRoutes.login),
    (AuthStatus.unauthenticated, detail, AppRoutes.login),
    (AuthStatus.authenticated, AppRoutes.splash, AppRoutes.products),
    (AuthStatus.authenticated, AppRoutes.login, AppRoutes.products),
    (AuthStatus.authenticated, AppRoutes.products, null),
    (AuthStatus.authenticated, detail, null),
  ];

  for (final (status, location, expected) in cases) {
    test('${status.name} at $location -> ${expected ?? 'stays'}', () {
      expect(authRedirect(status, location), expected);
    });
  }
}
