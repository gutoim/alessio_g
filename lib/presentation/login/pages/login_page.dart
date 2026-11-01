import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/login/bloc/login_bloc.dart';
import 'package:dummy_shop/presentation/login/bloc/login_state.dart';
import 'package:dummy_shop/presentation/login/widgets/login_form.dart';
import 'package:dummy_shop/presentation/login/widgets/login_header.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Login screen. Expects a [LoginBloc] above it (provided by the router).
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == LoginStatus.success,
      // Temporary: the session route guard takes over this navigation.
      listener: (context, state) => context.go(AppRoutes.products),
      child: Scaffold(
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
      ),
    );
  }
}
