import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';

/// Where the router must send the user for [status] when they are at
/// [location], or `null` to stay.
///
/// - unknown: wait on the splash screen.
/// - unauthenticated: only the login screen is reachable.
/// - authenticated: splash and login lead to the products list; every other
///   route stays as requested.
String? authRedirect(AuthStatus status, String location) {
  final onSplash = location == AppRoutes.splash;
  final onLogin = location == AppRoutes.login;

  return switch (status) {
    AuthStatus.unknown => onSplash ? null : AppRoutes.splash,
    AuthStatus.unauthenticated => onLogin ? null : AppRoutes.login,
    AuthStatus.authenticated => onSplash || onLogin ? AppRoutes.products : null,
  };
}
