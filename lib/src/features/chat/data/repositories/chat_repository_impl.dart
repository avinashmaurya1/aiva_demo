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
}
