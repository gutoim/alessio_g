import 'package:dummy_shop/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Password input with a show/hide toggle. Visibility is local UI state.
class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.onChanged,
    required this.onSubmitted,
    this.enabled = true,
    this.errorText,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;
  final bool enabled;
  final String? errorText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextField(
      enabled: widget.enabled,
      obscureText: _obscured,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: (_) => widget.onSubmitted(),
      decoration: InputDecoration(
        labelText: l10n.loginPasswordLabel,
        errorText: widget.errorText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          tooltip: _obscured ? l10n.loginShowPassword : l10n.loginHidePassword,
          icon: Icon(
            _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
    );
  }
}
