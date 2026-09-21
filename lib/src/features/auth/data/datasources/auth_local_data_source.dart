import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_token_model.dart';
import '../models/user_profile_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(AuthTokenModel token);
  Future<AuthTokenModel?> getToken();
  Future<void> saveUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getUserProfile();
  Future<void> saveRememberedCredentials({required String companyId, required String userName});
  Future<(String?, String?)> getRememberedCredentials();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _keyToken = 'aiva_auth_token';
  static const String _keyProfile = 'aiva_user_profile';
  static const String _keyCompanyId = 'aiva_saved_company_id';
  static const String _keyUserName = 'aiva_saved_user_name';

  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveToken(AuthTokenModel token) async {
    await _prefs.setString(_keyToken, jsonEncode(token.toJson()));
  }

  @override
  Future<AuthTokenModel?> getToken() async {
    final raw = _prefs.getString(_keyToken);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AuthTokenModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {
    await _prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  @override
  Future<UserProfileModel?> getUserProfile() async {
    final raw = _prefs.getString(_keyProfile);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfileModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveRememberedCredentials({
    required String companyId,
    required String userName,
  }) async {
    await _prefs.setString(_keyCompanyId, companyId);
    await _prefs.setString(_keyUserName, userName);
  }

  @override
  Future<(String?, String?)> getRememberedCredentials() async {
    final comp = _prefs.getString(_keyCompanyId);
    final user = _prefs.getString(_keyUserName);
    return (comp, user);
  }

  @override
  Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyProfile);
  }
}
