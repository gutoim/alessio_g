import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:dummy_shop/res/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Root widget: session, theme, localization and routing.
///
/// [sessionBloc] and [router] are passed in, not looked up, so tests can pump
/// the app with their own instances.
class App extends StatelessWidget {
  const App({required this.sessionBloc, required this.router, super.key});

  final SessionBloc sessionBloc;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sessionBloc,
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appTitle,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }
}
