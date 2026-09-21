import '../entities/chat_message.dart';
import '../entities/chat_session.dart';
import '../entities/sse_event.dart';

/// Contract for Chat streaming, session history, and artifacts
abstract class ChatRepository {
  /// Streams a single turn using SSE POST /api/chat/stream
  Stream<SseEvent> streamTurn({
    required String message,
    required String token,
    String? sessionId,
    String agent = 'root',
    Map<String, dynamic>? context,
  });

  /// Fetches an artifact payload by ID (GET /api/artifacts/{id})
  Future<Map<String, dynamic>?> getArtifact(String artifactId);

  /// Lists all past conversation sessions (GET /api/chat/sessions)
  Future<List<ChatSessionSummary>> getSessions(String token);

  /// Retrieves full message history for a session (GET /api/chat/sessions/{id})
  Future<List<ChatMessage>> getSessionMessages({
    required String sessionId,
    required String token,
  });

  /// Deletes all conversation sessions (DELETE /api/chat/sessions)
  Future<void> deleteAllSessions(String token);
}
