import '../../domain/entities/auth_token.dart';

/// Data Model for AuthToken serialization
class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.accessToken,
    super.refreshToken,
    super.travogBaseUrl,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
      travogBaseUrl: json['travogBaseUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'travogBaseUrl': travogBaseUrl,
    };
  }
}
