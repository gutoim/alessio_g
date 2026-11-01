import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/pages/login_page.dart';
import 'package:dummy_shop/presentation/product_detail/pages/product_detail_page.dart';
import 'package:dummy_shop/presentation/products/pages/products_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// Owns the app's single [GoRouter].
///
/// It is a singleton so the navigation stack survives widget rebuilds.
/// The auth redirect guard is added together with session handling.
///
/// Route builders are the composition points for screens: each one creates
/// the screen's BLoC from [getIt], so pages never touch the service locator.
@singleton
class AppRouter {
  final GoRouter config = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LoginBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) => const ProductsPage(),
        routes: [
          GoRoute(
            path: ':$_productIdParam',
            // A malformed id in a deep link goes back to the list instead of
            // failing in the detail page.
            redirect: (context, state) =>
                _productId(state) == null ? AppRoutes.products : null,
            builder: (context, state) =>
                ProductDetailPage(productId: _productId(state)!),
          ),
        ],
      ),
    ],
  );

  static const String _productIdParam = 'id';

  static int? _productId(GoRouterState state) =>
      int.tryParse(state.pathParameters[_productIdParam] ?? '');
}
