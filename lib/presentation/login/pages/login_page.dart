import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder. The login form and `LoginBloc` replace it in the auth feature.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FilledButton(
            onPressed: () => context.go(AppRoutes.products),
            child: Text(l10n.loginButton),
          ),
        ),
      ),
    );
  }
}
