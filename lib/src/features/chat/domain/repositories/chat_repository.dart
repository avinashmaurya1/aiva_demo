import '../entities/sse_event.dart';

/// Contract for Chat streaming and session communication
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
}
