import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/user.dart';
import 'package:dummy_shop/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<User>> call({
    required String username,
    required String password,
  }) => _repository.login(username: username, password: password);
}
