import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/app/router/auth_guard.dart';
import 'package:dummy_shop/presentation/app/router/stream_listenable.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/pages/login_page.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:dummy_shop/presentation/product_detail/pages/product_detail_page.dart';
import 'package:dummy_shop/presentation/products/bloc/products_bloc.dart';
import 'package:dummy_shop/presentation/products/bloc/products_event.dart';
import 'package:dummy_shop/presentation/products/pages/products_page.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:dummy_shop/presentation/splash/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// Owns the app's single [GoRouter].
///
/// It is a singleton so the navigation stack survives widget rebuilds.
/// Every navigation goes through [authRedirect], which follows the
/// [SessionBloc]. Screens never navigate after login or logout themselves.
///
/// Route builders are the composition points for screens: each one creates
/// the screen's BLoC from [getIt], so pages never touch the service locator.
///
/// Every route builds a [MaterialPage] itself (see [_page]).
@lazySingleton
class AppRouter {
  AppRouter(SessionBloc session) : _refresh = StreamListenable(session.stream) {
    config = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _refresh,
      redirect: (context, state) =>
          authRedirect(session.state.status, state.matchedLocation),
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          pageBuilder: (context, state) => _page(state, const SplashPage()),
        ),
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider(
              create: (_) => getIt<LoginBloc>(),
              child: const LoginPage(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.products,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider(
              create: (_) =>
                  getIt<ProductsBloc>()
                    ..add(const ProductsEvent.loadRequested()),
              child: const ProductsPage(),
            ),
          ),
          routes: [
            GoRoute(
              path: ':$_productIdParam',
              // A malformed id in a deep link goes back to the list instead of
              // failing in the detail page.
              redirect: (context, state) =>
                  _productId(state) == null ? AppRoutes.products : null,
              pageBuilder: (context, state) {
                final productId = _productId(state)!;
                // The list passes the tapped product as `extra`. A deep link
                // or a restored route has none, and loads by id instead.
                final preview = switch (state.extra) {
                  final Product product => product,
                  _ => null,
                };
                return _page(
                  state,
                  BlocProvider(
                    create: (_) => getIt<ProductDetailBloc>()
                      ..add(
                        ProductDetailEvent.loadRequested(
                          productId,
                          preview: preview,
                        ),
                      ),
                    child: ProductDetailPage(productId: productId),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  final StreamListenable _refresh;
  late final GoRouter config;

  static const String _productIdParam = 'id';

  /// Wraps a screen in a [MaterialPage], so it opens with the theme's page
  /// transition: a slide with swipe-back on iOS, predictive back on Android.
  ///
  /// With a plain `builder`, go_router 18 picks the page type itself. It only
  /// recognizes `MaterialApp` from the `material_ui` package, not the one from
  /// `package:flutter/material.dart` this app uses. So it falls back to pages
  /// without any transition, and iOS loses the swipe-back gesture.
  static Page<void> _page(GoRouterState state, Widget child) =>
      MaterialPage<void>(
        key: state.pageKey,
        name: state.name ?? state.path,
        restorationId: state.pageKey.value,
        child: child,
      );

  static int? _productId(GoRouterState state) =>
      int.tryParse(state.pathParameters[_productIdParam] ?? '');

  @disposeMethod
  void dispose() {
    config.dispose();
    _refresh.dispose();
  }
}
