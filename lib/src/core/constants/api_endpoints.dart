/// API Endpoints for AgenticBox backend
class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL of AgenticBox backend
  static const String baseUrl = 'https://ai-uat.quadlabs.net/api';


  // Auth endpoints
  static const String login = '$baseUrl/auth/login';
  static const String bootstrap = '$baseUrl/auth/bootstrap';
  static const String refresh = '$baseUrl/auth/refresh';
  static const String exchangeToken = '$baseUrl/auth/exchange-token';
  static const String consumeSession = '$baseUrl/auth/consume-session';

  // Chat endpoints
  static const String chatStream = '$baseUrl/chat/stream';
  static const String chatTurn = '$baseUrl/chat/turn';
  static const String chatSessions = '$baseUrl/chat/sessions';

  // Artifacts endpoint
  static const String artifacts = '$baseUrl/artifacts';

  /// Helper to get artifact by ID
  static String artifactById(String artifactId) => '$artifacts/$artifactId';

  /// Helper to get session by ID
  static String sessionById(String sessionId) => '$chatSessions/$sessionId';
}
