import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:dummy_shop/presentation/session/bloc/session_event.dart';
import 'package:dummy_shop/presentation/session/bloc/session_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockWatchAuthStatusUseCase watchAuthStatus;
  late MockLogoutUseCase logout;
  late StreamController<AuthStatus> authStatus;

  setUp(() {
    watchAuthStatus = MockWatchAuthStatusUseCase();
    logout = MockLogoutUseCase();
    authStatus = StreamController<AuthStatus>();
    when(() => watchAuthStatus()).thenAnswer((_) => authStatus.stream);
    when(() => logout()).thenAnswer((_) async {});
  });

  // Not awaited: closing a single-subscription stream nobody listened to
  // never completes.
  tearDown(() => unawaited(authStatus.close()));

  SessionBloc buildBloc() => SessionBloc(watchAuthStatus, logout);

  test('starts with an unknown status', () {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state, const SessionState());
    expect(bloc.state.status, AuthStatus.unknown);
  });

  blocTest<SessionBloc, SessionState>(
    'follows every auth status change once started',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SessionEvent.started());
      authStatus
        ..add(AuthStatus.unauthenticated)
        ..add(AuthStatus.authenticated)
        ..add(AuthStatus.unauthenticated);
    },
    expect: () => const [
      SessionState(status: AuthStatus.unauthenticated),
      SessionState(status: AuthStatus.authenticated),
      SessionState(status: AuthStatus.unauthenticated),
    ],
  );

  blocTest<SessionBloc, SessionState>(
    'logs out through the use case and waits for the status change',
    build: buildBloc,
    seed: () => const SessionState(status: AuthStatus.authenticated),
    act: (bloc) => bloc.add(const SessionEvent.logoutRequested()),
    expect: () => const <SessionState>[],
    verify: (_) => verify(() => logout()).called(1),
  );
}
