import 'package:flutter_test/flutter_test.dart';
import 'package:aiva_ai_agent/src/features/chat/domain/entities/sse_event.dart';
import 'package:aiva_ai_agent/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:aiva_ai_agent/src/features/chat/presentation/controllers/chat_bloc.dart';
import 'package:aiva_ai_agent/src/features/chat/presentation/controllers/chat_event.dart';

class FakeChatRepository implements ChatRepository {
  @override
  Stream<SseEvent> streamTurn({
    required String message,
    required String token,
    String? sessionId,
    String agent = 'root',
    Map<String, dynamic>? context,
  }) async* {
    yield const SseSessionEvent(sessionId: 'session_123', agent: 'root');
    yield const SseMessageEvent(text: 'I found flights from DEL to BOM', isFinal: false);
    yield const SseMessageEvent(text: ' starting at ₹4599.', isFinal: true);
    yield const SseDoneEvent(sessionId: 'session_123');
  }

  @override
  Future<Map<String, dynamic>?> getArtifact(String artifactId) async {
    return {
      'artifact_id': artifactId,
      'component': 'flight_results',
      'payload': {'count': 1},
    };
  }
}

void main() {
  test('ChatBloc processes streaming turn and accumulates assistant message', () async {
    final chatRepo = FakeChatRepository();
    final chatBloc = ChatBloc(
      chatRepository: chatRepo,
      tokenProvider: () => 'mock_token',
    );

    expect(chatBloc.state.messages, isEmpty);
    expect(chatBloc.state.isStreaming, isFalse);

    chatBloc.add(const ChatTurnSubmitted(message: 'Find flights to BOM'));

    await expectLater(
      chatBloc.stream,
      emitsThrough(
        predicate<dynamic>((state) {
          return state.messages.length == 2 &&
              state.sessionId == 'session_123' &&
              state.messages.last.text.contains('starting at ₹4599.') &&
              state.isStreaming == false;
        }),
      ),
    );

    chatBloc.close();
  });
}
