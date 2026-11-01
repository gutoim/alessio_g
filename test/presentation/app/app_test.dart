import 'package:dummy_shop/presentation/app/app.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/login/pages/login_page.dart';
import 'package:dummy_shop/presentation/product_detail/pages/product_detail_page.dart';
import 'package:dummy_shop/presentation/products/pages/products_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late GoRouter router;

  setUp(() => router = AppRouter().config);
  tearDown(() => router.dispose());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(App(router: router));
    await tester.pumpAndSettle();
  }

  testWidgets('starts on the login page with localized strings', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('log in button opens the products page', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Log in'));
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
