import '../../../../core/error/exceptions.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthToken> login({
    required String companyId,
    required String userName,
    required String password,
    String? accountNo,
    String source = 'SBT',
  }) async {
    try {
      final tokenModel = await remoteDataSource.login(
        companyId: companyId,
        userName: userName,
        password: password,
        accountNo: accountNo,
        source: source,
      );

      await localDataSource.saveToken(tokenModel);
      await localDataSource.saveRememberedCredentials(
        companyId: companyId,
        userName: userName,
      );

      return tokenModel;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException('Login failed: $e');
    }
  }

  @override
  Future<UserProfile> bootstrap({
    required String accessToken,
    required String travogBaseUrl,
  }) async {
    try {
      final profileModel = await remoteDataSource.bootstrap(
        accessToken: accessToken,
        travogBaseUrl: travogBaseUrl,
      );

      await localDataSource.saveUserProfile(profileModel);
      return profileModel;
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException('Bootstrap failed: $e');
    }
  }

  @override
  Future<AuthToken?> getSavedToken() {
    return localDataSource.getToken();
  }

  @override
  Future<UserProfile?> getSavedUserProfile() {
    return localDataSource.getUserProfile();
  }

  @override
  Future<AuthToken> refreshToken({
    required String refreshToken,
    required String travogBaseUrl,
  }) async {
    final token = await remoteDataSource.refreshToken(
      refreshToken: refreshToken,
      travogBaseUrl: travogBaseUrl,
    );
    await localDataSource.saveToken(token);
    return token;
  }

  @override
  Future<void> logout() {
    return localDataSource.clearSession();
  }
}
