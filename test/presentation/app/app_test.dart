import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/app.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/pages/login_page.dart';
import 'package:dummy_shop/presentation/product_detail/pages/product_detail_page.dart';
import 'package:dummy_shop/presentation/products/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockLoginUseCase login;
  late GoRouter router;

  setUp(() {
    login = MockLoginUseCase();
    getIt.registerFactory<LoginBloc>(() => LoginBloc(login));
    router = AppRouter().config;
  });

  tearDown(() async {
    router.dispose();
    await getIt.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(App(router: router));
    await tester.pumpAndSettle();
  }

  testWidgets('starts on the login page with localized strings', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);
  });

  testWidgets('a successful login opens the products page', (tester) async {
    when(
      () => anyLogin(login),
    ).thenAnswer((_) async => const Result.ok(testUser));
    await pumpApp(tester);

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

  testWidgets('deep link opens product detail with the id from the path', (
    tester,
  ) async {
    await pumpApp(tester);

    router.go(AppRoutes.productDetail(42));
    await tester.pumpAndSettle();

    final page = tester.widget<ProductDetailPage>(
      find.byType(ProductDetailPage),
    );
    expect(page.productId, 42);
  });

  testWidgets('non-numeric product id redirects to the products page', (
    tester,
  ) async {
    await pumpApp(tester);

    router.go('${AppRoutes.products}/abc');
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailPage), findsNothing);
    expect(find.byType(ProductsPage), findsOneWidget);
  });
}
