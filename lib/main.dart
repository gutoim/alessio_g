import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/app.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  configureDependencies();
  runApp(App(router: getIt<AppRouter>().config));
}
