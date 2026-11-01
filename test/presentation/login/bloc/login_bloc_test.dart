import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/user.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/bloc/login_event.dart';
import 'package:dummy_shop/presentation/login/bloc/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockLoginUseCase login;

  const filledIn = LoginState(username: 'emilys', password: 'emilyspass');

  setUp(() => login = MockLoginUseCase());

  LoginBloc buildBloc() => LoginBloc(login);

  test('starts idle with empty fields and no errors', () {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state, const LoginState());
    expect(bloc.state.showUsernameError, isFalse);
    expect(bloc.state.showPasswordError, isFalse);
  });

  group('field changes', () {
    blocTest<LoginBloc, LoginState>(
      'store the entered values',
      build: buildBloc,
      act: (bloc) => bloc
        ..add(const LoginEvent.usernameChanged('emilys'))
        ..add(const LoginEvent.passwordChanged('emilyspass')),
      expect: () => const [
        LoginState(username: 'emilys'),
        LoginState(username: 'emilys', password: 'emilyspass'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'clear a previous login error',
      build: buildBloc,
      seed: () => filledIn.copyWith(
        password: 'wrong',
        status: LoginStatus.failure,
        failure: const Failure.invalidCredentials(),
      ),
      act: (bloc) => bloc.add(const LoginEvent.passwordChanged('emilyspass')),
      expect: () => const [filledIn],
    );
  });

  group('submit', () {
    blocTest<LoginBloc, LoginState>(
      'with empty fields shows the field errors and does not log in',
      build: buildBloc,
      act: (bloc) => bloc.add(const LoginEvent.submitted()),
      expect: () => [
        isA<LoginState>()
            .having((s) => s.showUsernameError, 'showUsernameError', isTrue)
            .having((s) => s.showPasswordError, 'showPasswordError', isTrue)
            .having((s) => s.status, 'status', LoginStatus.idle),
      ],
      verify: (_) => verifyNever(() => anyLogin(login)),
    );

    blocTest<LoginBloc, LoginState>(
      'treats a username of only spaces as empty',
      build: buildBloc,
      seed: () => filledIn.copyWith(username: '   '),
      act: (bloc) => bloc.add(const LoginEvent.submitted()),
      expect: () => [
        isA<LoginState>()
            .having((s) => s.showUsernameError, 'showUsernameError', isTrue)
            .having((s) => s.showPasswordError, 'showPasswordError', isFalse),
      ],
      verify: (_) => verifyNever(() => anyLogin(login)),
    );

    blocTest<LoginBloc, LoginState>(
      'logs in with the trimmed username and reports success',
      setUp: () => when(
        () => anyLogin(login),
      ).thenAnswer((_) async => const Result.ok(testUser)),
      build: buildBloc,
      seed: () => filledIn.copyWith(username: '  emilys '),
      act: (bloc) => bloc.add(const LoginEvent.submitted()),
      expect: () => [
        filledIn.copyWith(
          username: '  emilys ',
          status: LoginStatus.submitting,
        ),
        filledIn.copyWith(username: '  emilys ', status: LoginStatus.success),
      ],
      verify: (_) => verify(
        () => login(username: 'emilys', password: 'emilyspass'),
      ).called(1),
    );

    blocTest<LoginBloc, LoginState>(
      'reports the failure when the login is rejected',
      setUp: () => when(
        () => anyLogin(login),
      ).thenAnswer((_) async => const Result.err(Failure.invalidCredentials())),
      build: buildBloc,
      seed: () => filledIn,
      act: (bloc) => bloc.add(const LoginEvent.submitted()),
      expect: () => [
        filledIn.copyWith(status: LoginStatus.submitting),
        filledIn.copyWith(
          status: LoginStatus.failure,
          failure: const Failure.invalidCredentials(),
        ),
      ],
    );

    final pendingLogin = Completer<Result<User>>();
    blocTest<LoginBloc, LoginState>(
      'ignores a second submit while the first one is running',
      setUp: () =>
          when(() => anyLogin(login)).thenAnswer((_) => pendingLogin.future),
      build: buildBloc,
      seed: () => filledIn,
      act: (bloc) async {
        bloc
          ..add(const LoginEvent.submitted())
          ..add(const LoginEvent.submitted());
        await Future<void>.delayed(Duration.zero);
        pendingLogin.complete(const Result.ok(testUser));
      },
      expect: () => [
        filledIn.copyWith(status: LoginStatus.submitting),
        filledIn.copyWith(status: LoginStatus.success),
      ],
      verify: (_) => verify(() => anyLogin(login)).called(1),
    );
  });
}
