import 'package:dummy_shop/domain/core/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

enum LoginStatus { idle, submitting, success, failure }

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String username,
    @Default('') String password,
    @Default(LoginStatus.idle) LoginStatus status,

    /// Field errors are hidden until the user tries to submit.
    @Default(false) bool showValidationErrors,

    /// Set when [status] is [LoginStatus.failure].
    Failure? failure,
  }) = _LoginState;

  const LoginState._();

  bool get isSubmitting => status == LoginStatus.submitting;

  /// The form stays disabled after a successful login until the router has
  /// left the screen, so it does not flash back to editable.
  bool get isBusy =>
      status == LoginStatus.submitting || status == LoginStatus.success;

  bool get isValid => username.trim().isNotEmpty && password.isNotEmpty;

  bool get showUsernameError => showValidationErrors && username.trim().isEmpty;

  bool get showPasswordError => showValidationErrors && password.isEmpty;
}
