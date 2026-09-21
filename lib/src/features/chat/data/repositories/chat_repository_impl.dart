import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/entities/sse_event.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<SseEvent> streamTurn({
    required String message,
    required String token,
    String? sessionId,
    String agent = 'root',
    Map<String, dynamic>? context,
  }) {
    return remoteDataSource.streamChatTurn(
      message: message,
      token: token,
      sessionId: sessionId,
      agent: agent,
      context: context,
    );
  }

  @override
  Future<Map<String, dynamic>?> getArtifact(String artifactId) {
    return remoteDataSource.fetchArtifact(artifactId);
  }

  @override
  Future<List<ChatSessionSummary>> getSessions(String token) {
    return remoteDataSource.fetchSessions(token);
  }

  @override
  Future<List<ChatMessage>> getSessionMessages({
    required String sessionId,
    required String token,
  }) {
    return remoteDataSource.fetchSessionMessages(
      sessionId: sessionId,
      token: token,
    );
  }

  @override
  Future<void> deleteAllSessions(String token) {
    return remoteDataSource.deleteAllSessions(token);
  }
}
