import '../../domain/entities/user_profile.dart';

/// Data Model for UserProfile and bootstrap session
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.userId,
    required super.userName,
    required super.companyId,
    super.currency,
    super.travogBaseUrl,
    super.rawPayload,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final loginPayload = json['loginPayload'] as Map<String, dynamic>? ?? {};
    final sessionProfile = json['sessionProfile'] as Map<String, dynamic>? ?? {};

    final userId = sessionProfile['user_id']?.toString() ??
        loginPayload['uid']?.toString() ??
        loginPayload['userId']?.toString() ??
        '';

    final userName = sessionProfile['user_name']?.toString() ??
        loginPayload['userName']?.toString() ??
        '';

    final companyId = sessionProfile['company_id']?.toString() ??
        loginPayload['companyId']?.toString() ??
        '';

    final currency = json['currency']?.toString() ??
        sessionProfile['currency']?.toString() ??
        'INR';

    final travogBaseUrl = json['travogBaseUrl']?.toString() ??
        sessionProfile['travogBaseUrl']?.toString();

    return UserProfileModel(
      userId: userId,
      userName: userName,
      companyId: companyId,
      currency: currency,
      travogBaseUrl: travogBaseUrl,
      rawPayload: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'companyId': companyId,
      'currency': currency,
      'travogBaseUrl': travogBaseUrl,
      'rawPayload': rawPayload,
    };
  }
}
