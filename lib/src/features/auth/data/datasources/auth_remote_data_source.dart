import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login({
    required String companyId,
    required String userName,
    required String password,
    String? accountNo,
    String source = 'SBT',
  });

  Future<UserProfileModel> bootstrap({
    required String accessToken,
    required String travogBaseUrl,
  });

  Future<AuthTokenModel> refreshToken({
    required String refreshToken,
    required String travogBaseUrl,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AuthTokenModel> login({
    required String companyId,
    required String userName,
    required String password,
    String? accountNo,
    String source = 'SBT',
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: {
        'companyId': companyId,
        'accountNo': accountNo ?? '',
        'userName': userName,
        'password': password,
        'source': source,
      },
    );

    if (response['success'] == false && response['message'] != null) {
      throw AuthException(response['message'].toString());
    }

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const AuthException('Invalid login response from server');
    }

    return AuthTokenModel.fromJson(data);
  }

  @override
  Future<UserProfileModel> bootstrap({
    required String accessToken,
    required String travogBaseUrl,
  }) async {
    final uri = Uri.parse(ApiEndpoints.bootstrap).replace(
      queryParameters: {'travogBaseUrl': travogBaseUrl},
    );

    final response = await _apiClient.get(
      uri.toString(),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const AuthException('Invalid bootstrap response');
    }

    return UserProfileModel.fromJson(data);
  }

  @override
  Future<AuthTokenModel> refreshToken({
    required String refreshToken,
    required String travogBaseUrl,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.refresh,
      body: {
        'refreshToken': refreshToken,
        'travogBaseUrl': travogBaseUrl,
      },
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const AuthException('Failed to refresh token');
    }

    return AuthTokenModel.fromJson(data);
  }
}
