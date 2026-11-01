import 'dart:async';

import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/user.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockLoginUseCase login;

  final usernameField = find.widgetWithText(TextField, 'Username');
  final passwordField = find.widgetWithText(TextField, 'Password');
  final loginButton = find.byType(FilledButton);

  setUp(() => login = MockLoginUseCase());

  /// Pumps the real [LoginBloc] (with a mocked use case) inside a router that
  /// has a stand-in products page, so navigation after login is visible.
  ///
  /// The bloc is created by a [BlocProvider], like in the app, so the widget
  /// tree closes it. Awaiting `bloc.close()` inside `testWidgets` never
  /// completes because of the fake clock.
  Future<void> pumpLoginPage(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.login,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (_, _) => BlocProvider(
            create: (_) => LoginBloc(login),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.products,
          builder: (_, _) => const Text('products page'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterCredentials(
    WidgetTester tester, {
    String username = 'emilys',
    String password = 'emilyspass',
  }) async {
    await tester.enterText(usernameField, username);
    await tester.enterText(passwordField, password);
  }

  testWidgets('shows field errors and does not log in when empty', (
    tester,
  ) async {
    await pumpLoginPage(tester);

    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Enter your username'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    verifyNever(() => anyLogin(login));
  });

  testWidgets('logs in with the trimmed username and opens the products page', (
    tester,
  ) async {
    when(
      () => anyLogin(login),
    ).thenAnswer((_) async => const Result.ok(testUser));
    await pumpLoginPage(tester);

    await enterCredentials(tester, username: '  emilys ');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(() => login(username: 'emilys', password: 'emilyspass')).called(1);
    expect(find.text('products page'), findsOneWidget);
  });

  testWidgets('submits from the keyboard "done" action', (tester) async {
    when(
      () => anyLogin(login),
    ).thenAnswer((_) async => const Result.ok(testUser));
    await pumpLoginPage(tester);

    await enterCredentials(tester);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    verify(() => anyLogin(login)).called(1);
  });

  testWidgets('shows a spinner and disables the form while logging in', (
    tester,
  ) async {
    final pendingLogin = Completer<Result<User>>();
    when(() => anyLogin(login)).thenAnswer((_) => pendingLogin.future);
    await pumpLoginPage(tester);

    await enterCredentials(tester);
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.widget<FilledButton>(loginButton).onPressed, isNull);
    expect(tester.widget<TextField>(usernameField).enabled, isFalse);
    expect(tester.widget<TextField>(passwordField).enabled, isFalse);

    pendingLogin.complete(const Result.err(Failure.network()));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.widget<TextField>(usernameField).enabled, isTrue);
  });

  testWidgets('shows the error message when the login is rejected', (
    tester,
  ) async {
    when(
      () => anyLogin(login),
    ).thenAnswer((_) async => const Result.err(Failure.invalidCredentials()));
    await pumpLoginPage(tester);

    await enterCredentials(tester, password: 'wrong');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Wrong username or password.'), findsOneWidget);
    expect(find.text('products page'), findsNothing);
  });

  testWidgets('hides the error message once a field is edited', (tester) async {
    when(
      () => anyLogin(login),
    ).thenAnswer((_) async => const Result.err(Failure.network()));
    await pumpLoginPage(tester);

    await enterCredentials(tester);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(
      find.text('No internet connection. Check your connection and try again.'),
      findsOneWidget,
    );

    await tester.enterText(passwordField, 'emilyspass!');
    await tester.pump();

    expect(
      find.text('No internet connection. Check your connection and try again.'),
      findsNothing,
    );
  });

  testWidgets('toggles the password visibility', (tester) async {
    await pumpLoginPage(tester);

    bool isObscured() => tester.widget<TextField>(passwordField).obscureText;
    expect(isObscured(), isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(isObscured(), isFalse);

    await tester.tap(find.byTooltip('Hide password'));
    await tester.pump();
    expect(isObscured(), isTrue);
  });
}
