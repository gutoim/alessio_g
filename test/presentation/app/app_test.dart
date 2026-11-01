import 'dart:async';

import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/app.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/pages/login_page.dart';
import 'package:dummy_shop/presentation/product_detail/pages/product_detail_page.dart';
import 'package:dummy_shop/presentation/products/bloc/products_bloc.dart';
import 'package:dummy_shop/presentation/products/pages/products_page.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:dummy_shop/presentation/session/bloc/session_event.dart';
import 'package:dummy_shop/presentation/splash/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

/// End-to-end navigation: real session bloc, router and screens, with the
/// use cases mocked. [authStatus] plays the role of the auth repository.
void main() {
  late MockLoginUseCase login;
  late MockLogoutUseCase logout;
  late MockWatchAuthStatusUseCase watchAuthStatus;
  late MockGetProductsUseCase getProducts;
  late StreamController<AuthStatus> authStatus;
  late AppRouter appRouter;

  setUp(() {
    login = MockLoginUseCase();
    logout = MockLogoutUseCase();
    watchAuthStatus = MockWatchAuthStatusUseCase();
    getProducts = MockGetProductsUseCase();

    when(() => watchAuthStatus()).thenAnswer((_) => authStatus.stream);
    when(
      () => logout(),
    ).thenAnswer((_) async => authStatus.add(AuthStatus.unauthenticated));
    when(() => anyLogin(login)).thenAnswer((_) async {
      authStatus.add(AuthStatus.authenticated);
      return const Result.ok(testUser);
    });

    when(
      () => anyGetProducts(getProducts),
    ).thenAnswer((_) async => Result.ok(productsPage([testProduct])));

    getIt
      ..registerFactory<LoginBloc>(() => LoginBloc(login))
      ..registerFactory<ProductsBloc>(() => ProductsBloc(getProducts));
  });

  tearDown(getIt.reset);

  /// Builds the session, router and app inside the test body, on the test's
  /// fake clock. Built in `setUp` instead, their streams would run on the real
  /// event loop, which never gets a turn during a widget test.
  Future<void> pumpApp(WidgetTester tester) async {
    authStatus = StreamController<AuthStatus>();
    final session = SessionBloc(watchAuthStatus, logout)
      ..add(const SessionEvent.started());
    appRouter = AppRouter(session);
    addTearDown(() {
      appRouter.dispose();
      // Not awaited: on the fake clock these futures never complete.
      unawaited(session.close());
      unawaited(authStatus.close());
    });

    await tester.pumpWidget(
      App(sessionBloc: session, router: appRouter.config),
    );
    await tester.pump();
  }

  Future<void> givenStatus(WidgetTester tester, AuthStatus status) async {
    authStatus.add(status);
    await tester.pumpAndSettle();
  }

  testWidgets('shows the splash screen until the stored session is read', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(SplashPage), findsOneWidget);

    await givenStatus(tester, AuthStatus.unauthenticated);

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('a stored session opens the products list directly', (
    tester,
  ) async {
    await pumpApp(tester);
    await givenStatus(tester, AuthStatus.authenticated);

    expect(find.byType(ProductsPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('logging in opens the products list', (tester) async {
    await pumpApp(tester);
    await givenStatus(tester, AuthStatus.unauthenticated);

    await tester.enterText(
      find.widgetWithText(TextField, 'Username'),
      'emilys',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'emilyspass',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductsPage), findsOneWidget);
  });

  testWidgets('logging out returns to the login screen', (tester) async {
    await pumpApp(tester);
    await givenStatus(tester, AuthStatus.authenticated);

    await tester.tap(find.byTooltip('Log out'));
    await tester.pumpAndSettle();

    verify(() => logout()).called(1);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('a logged-out user cannot open a product', (tester) async {
    await pumpApp(tester);
    await givenStatus(tester, AuthStatus.unauthenticated);

    appRouter.config.go(AppRoutes.productDetail(42));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailPage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('a logged-in user is sent from login to the products list', (
    tester,
  ) async {
    await pumpApp(tester);
    await givenStatus(tester, AuthStatus.authenticated);

    appRouter.config.go(AppRoutes.login);
    await tester.pumpAndSettle();

    expect(find.byType(ProductsPage), findsOneWidget);
  });

  testWidgets('opens product detail with the id from the path', (tester) async {
    await pumpApp(tester);
    await givenStatus(tester, AuthStatus.authenticated);

    appRouter.config.go(AppRoutes.productDetail(42));
    await tester.pumpAndSettle();

    final page = tester.widget<ProductDetailPage>(
      find.byType(ProductDetailPage),
    );
    expect(page.productId, 42);
  });

  testWidgets('a non-numeric product id redirects to the products list', (
    tester,
  ) async {
    await pumpApp(tester);
    await givenStatus(tester, AuthStatus.authenticated);

    appRouter.config.go('${AppRoutes.products}/abc');
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailPage), findsNothing);
    expect(find.byType(ProductsPage), findsOneWidget);
  });
}
