/// Events for AuthBloc
sealed class AuthEvent {
  const AuthEvent();
}

/// App started / check existing session
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// User submitted login form
class AuthLoginSubmitted extends AuthEvent {
  final String companyId;
  final String userName;
  final String password;
  final String? accountNo;
  final String source;

  const AuthLoginSubmitted({
    required this.companyId,
    required this.userName,
    required this.password,
    this.accountNo,
    this.source = 'SBT',
  });
}

/// User logged out
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
