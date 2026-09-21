/// Base class for all domain layer failures
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Server or API failure
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

/// Authentication and authorization failure
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.statusCode});
}

/// Network connectivity failure
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Please check your internet connection']);
}

/// Local cache or storage failure
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Unable to access local storage']);
}
