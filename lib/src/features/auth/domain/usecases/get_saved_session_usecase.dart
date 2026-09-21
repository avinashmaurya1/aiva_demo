import '../entities/auth_token.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// UseCase to retrieve cached session upon app startup
class GetSavedSessionUseCase {
  final AuthRepository _repository;

  GetSavedSessionUseCase(this._repository);

  Future<(AuthToken?, UserProfile?)> call() async {
    final token = await _repository.getSavedToken();
    final profile = await _repository.getSavedUserProfile();
    return (token, profile);
  }
}
