import '../entities/auth_token.dart';
import '../entities/user_profile.dart';

/// Contract for Authentication repository
abstract class AuthRepository {
  /// Logs in user via companyId, userName, and password
  Future<AuthToken> login({
    required String companyId,
    required String userName,
    required String password,
    String? accountNo,
    String source = 'SBT',
  });

  /// Fetches authenticated session profile
  Future<UserProfile> bootstrap({
    required String accessToken,
    required String travogBaseUrl,
  });

  /// Gets currently cached token
  Future<AuthToken?> getSavedToken();

  /// Gets currently cached user profile
  Future<UserProfile?> getSavedUserProfile();

  /// Refreshes access token
  Future<AuthToken> refreshToken({
    required String refreshToken,
    required String travogBaseUrl,
  });

  /// Clears active session
  Future<void> logout();
}
