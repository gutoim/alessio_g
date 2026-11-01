import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/widgets/login_form.dart';
import 'package:dummy_shop/presentation/login/widgets/login_header.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

/// Login screen. Expects a [LoginBloc] above it (provided by the router).
///
/// It does not navigate after a successful login: the session changes to
/// authenticated and the router's guard opens the products list.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              // Keeps the form readable on tablets and in landscape.
              constraints: const BoxConstraints(maxWidth: 400),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  SizedBox(height: AppSpacing.xl),
                  LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
