import 'package:dummy_shop/injection/injection.dart';
import 'package:dummy_shop/presentation/app/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(getIt.reset);

  test('registers AppRouter as a singleton', () {
    configureDependencies();

    expect(getIt<AppRouter>(), same(getIt<AppRouter>()));
  });
}
