import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dummy_shop/domain/use_cases/logout_use_case.dart';
import 'package:dummy_shop/domain/use_cases/watch_auth_status_use_case.dart';
import 'package:dummy_shop/presentation/session/bloc/session_event.dart';
import 'package:dummy_shop/presentation/session/bloc/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// App-wide session status. The router's guard follows it, so logging in,
/// logging out and an expired session all navigate automatically.
@lazySingleton
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc(this._watchAuthStatus, this._logout)
    : super(const SessionState()) {
    on<SessionStarted>(_onStarted, transformer: droppable());
    on<SessionLogoutRequested>(_onLogoutRequested, transformer: droppable());
  }

  final WatchAuthStatusUseCase _watchAuthStatus;
  final LogoutUseCase _logout;

  Future<void> _onStarted(SessionStarted event, Emitter<SessionState> emit) =>
      emit.forEach(
        _watchAuthStatus(),
        onData: (status) => SessionState(status: status),
      );

  // The new status arrives through the stream from `_onStarted`.
  Future<void> _onLogoutRequested(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) => _logout();

  @override
  @disposeMethod
  Future<void> close() => super.close();
}
