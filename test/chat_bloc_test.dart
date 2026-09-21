import 'package:flutter_test/flutter_test.dart';
import 'package:aiva_ai_agent/src/features/chat/domain/entities/chat_message.dart';
import 'package:aiva_ai_agent/src/features/chat/domain/entities/chat_session.dart';
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

  @override
  Future<List<ChatSessionSummary>> getSessions(String token) async {
    return [
      const ChatSessionSummary(
        id: 'session_123',
        title: 'Flight DEL to BOM',
      ),
    ];
  }

  @override
  Future<List<ChatMessage>> getSessionMessages({required String sessionId, required String token}) async {
    return [
      ChatMessage(
        id: 'hist_1',
        text: 'Find flights to BOM',
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        id: 'hist_2',
        text: 'Found 3 morning flights',
        sender: MessageSender.agent,
        timestamp: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> deleteAllSessions(String token) async {}
}

void main() {
  late FakeChatRepository chatRepo;
  late ChatBloc chatBloc;

  setUp(() {
    chatRepo = FakeChatRepository();
    chatBloc = ChatBloc(
      chatRepository: chatRepo,
      tokenProvider: () => 'mock_token',
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  test('ChatBloc processes streaming turn and preserves session_id', () async {
    expect(chatBloc.state.messages, isEmpty);
    expect(chatBloc.state.sessionId, isNull);

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
  });

  test('ChatBloc fetches session list and loads past session history', () async {
    chatBloc.add(const ChatSessionsFetchRequested());

    await expectLater(
      chatBloc.stream,
      emitsThrough(
        predicate<dynamic>((state) {
          return state.sessions.isNotEmpty && state.sessions.first.id == 'session_123';
        }),
      ),
    );

    // Select past session
    chatBloc.add(const ChatSessionSelected('session_123'));

    await expectLater(
      chatBloc.stream,
      emitsThrough(
        predicate<dynamic>((state) {
          return state.sessionId == 'session_123' &&
              state.messages.length == 2 &&
              state.messages.first.text == 'Find flights to BOM';
        }),
      ),
    );
  });

  test('ChatBloc resets active conversation on ChatNewSessionRequested', () async {
    chatBloc.add(const ChatSessionSelected('session_123'));
    await expectLater(chatBloc.stream, emitsThrough(predicate<dynamic>((state) => state.sessionId == 'session_123')));

    chatBloc.add(const ChatNewSessionRequested());
    await expectLater(chatBloc.stream, emitsThrough(predicate<dynamic>((state) => state.sessionId == null && state.messages.isEmpty)));
  });
}
