import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/failure_message.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/bloc/login_event.dart';
import 'package:dummy_shop/presentation/login/bloc/login_state.dart';
import 'package:dummy_shop/presentation/login/widgets/password_field.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Username and password fields, the login error and the submit button.
///
/// All values live in [LoginBloc]: the widgets only render the state and
/// forward input as events.
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<LoginBloc>();
    void submit() => bloc.add(const LoginEvent.submitted());

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                enabled: !state.isSubmitting,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: const [AutofillHints.username],
                textInputAction: TextInputAction.next,
                onChanged: (value) =>
                    bloc.add(LoginEvent.usernameChanged(value)),
                decoration: InputDecoration(
                  labelText: l10n.loginUsernameLabel,
                  errorText: state.showUsernameError
                      ? l10n.loginUsernameRequired
                      : null,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PasswordField(
                enabled: !state.isSubmitting,
                errorText: state.showPasswordError
                    ? l10n.loginPasswordRequired
                    : null,
                onChanged: (value) =>
                    bloc.add(LoginEvent.passwordChanged(value)),
                onSubmitted: submit,
              ),
              if (state.failure case final failure?) ...[
                const SizedBox(height: AppSpacing.md),
                _FailureMessage(failure.message(l10n)),
              ],
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: state.isSubmitting ? null : submit,
                child: state.isSubmitting
                    ? Semantics(
                        label: l10n.loginInProgress,
                        child: const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Text(l10n.loginButton),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FailureMessage extends StatelessWidget {
  const _FailureMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // A live region makes screen readers announce the error when it appears.
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: colors.onErrorContainer),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
