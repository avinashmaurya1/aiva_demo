import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

/// UseCase to authenticate user credentials
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthToken> call({
    required String companyId,
    required String userName,
    required String password,
    String? accountNo,
    String source = 'SBT',
  }) {
    return _repository.login(
      companyId: companyId,
      userName: userName,
      password: password,
      accountNo: accountNo,
      source: source,
    );
  }
}
