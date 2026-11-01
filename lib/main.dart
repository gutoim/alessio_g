import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/app.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:dummy_shop/presentation/session/bloc/session_event.dart';
import 'package:flutter/material.dart';

void main() {
  configureDependencies();

  final sessionBloc = getIt<SessionBloc>()..add(const SessionEvent.started());
  runApp(App(sessionBloc: sessionBloc, router: getIt<AppRouter>().config));
}
