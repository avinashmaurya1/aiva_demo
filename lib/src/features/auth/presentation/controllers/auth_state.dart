import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user_profile.dart';

/// Sealed UI states for AuthBloc
sealed class AuthState {
  const AuthState();
}

/// Initial uninitialized state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Login or bootstrap in progress
class AuthLoading extends AuthState {
  final String? message;
  const AuthLoading([this.message]);
}

/// Authenticated state with token and user profile
class Authenticated extends AuthState {
  final AuthToken token;
  final UserProfile? userProfile;

  const Authenticated({
    required this.token,
    this.userProfile,
  });

  @override
  String toString() => 'Authenticated(user: ${userProfile?.userName ?? 'Unknown'}, company: ${userProfile?.companyId})';
}

/// Unauthenticated state (user needs to log in)
class Unauthenticated extends AuthState {
  final String? savedCompanyId;
  final String? savedUserName;

  const Unauthenticated({
    this.savedCompanyId,
    this.savedUserName,
  });
}

/// Authentication failed
class AuthFailureState extends AuthState {
  final String message;

  const AuthFailureState(this.message);

  @override
  String toString() => 'AuthFailureState(message: $message)';
}
