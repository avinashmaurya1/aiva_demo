/// Domain entity for authenticated User Profile & Bootstrap context
class UserProfile {
  final String userId;
  final String userName;
  final String companyId;
  final String currency;
  final String? travogBaseUrl;
  final Map<String, dynamic> rawPayload;

  const UserProfile({
    required this.userId,
    required this.userName,
    required this.companyId,
    this.currency = 'INR',
    this.travogBaseUrl,
    this.rawPayload = const {},
  });

  @override
  String toString() => 'UserProfile(userName: $userName, companyId: $companyId, currency: $currency)';
}
