import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/use_cases/login_use_case.dart';
import 'package:dummy_shop/presentation/login/bloc/login_event.dart';
import 'package:dummy_shop/presentation/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._login) : super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    // A double tap on "Log in" must not send two requests.
    on<LoginSubmitted>(_onSubmitted, transformer: droppable());
  }

  final LoginUseCase _login;

  // Editing a field clears a previous login error.
  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) => emit(
    state.copyWith(
      username: event.username,
      status: LoginStatus.idle,
      failure: null,
    ),
  );

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) => emit(
    state.copyWith(
      password: event.password,
      status: LoginStatus.idle,
      failure: null,
    ),
  );

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(showValidationErrors: true));
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, failure: null));

    final result = await _login(
      username: state.username.trim(),
      password: state.password,
    );

    switch (result) {
      case Ok():
        emit(state.copyWith(status: LoginStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: LoginStatus.failure, failure: failure));
    }
  }
}
