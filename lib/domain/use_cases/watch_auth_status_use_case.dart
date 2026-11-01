import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchAuthStatusUseCase {
  const WatchAuthStatusUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthStatus> call() => _repository.watchStatus();
}
