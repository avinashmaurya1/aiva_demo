/// Domain entity for Authentication Tokens
class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final String? travogBaseUrl;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    this.travogBaseUrl,
  });

  @override
  String toString() => 'AuthToken(accessToken: ${accessToken.substring(0, 10)}..., travogBaseUrl: $travogBaseUrl)';
}
