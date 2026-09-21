import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// UseCase to fetch user session profile
class GetBootstrapUseCase {
  final AuthRepository _repository;

  GetBootstrapUseCase(this._repository);

  Future<UserProfile> call({
    required String accessToken,
    required String travogBaseUrl,
  }) {
    return _repository.bootstrap(
      accessToken: accessToken,
      travogBaseUrl: travogBaseUrl,
    );
  }
}
