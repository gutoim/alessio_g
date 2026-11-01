import 'package:dummy_shop/injection/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// Global service locator.
///
/// Resolve dependencies only at composition points (`main.dart` and route
/// builders). Classes receive their dependencies through the constructor.
final GetIt getIt = GetIt.instance;

/// Registers every class annotated with `@injectable`, `@singleton` or
/// `@lazySingleton`.
///
/// Regenerate `injection.config.dart` after changing annotations:
/// `dart run build_runner build --delete-conflicting-outputs`
@InjectableInit()
void configureDependencies() => getIt.init();
