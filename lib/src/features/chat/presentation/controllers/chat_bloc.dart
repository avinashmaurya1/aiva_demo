import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/sse_event.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final String Function() tokenProvider;

  ChatBloc({
    required this.chatRepository,
    required this.tokenProvider,
  }) : super(const ChatState()) {
    on<ChatTurnSubmitted>(_onChatTurnSubmitted);
    on<ChatArtifactPayloadLoaded>(_onChatArtifactPayloadLoaded);
    on<ChatSessionReset>(_onChatSessionReset);
  }

  Future<void> _onChatTurnSubmitted(
    ChatTurnSubmitted event,
    Emitter<ChatState> emit,
  ) async {
    final token = tokenProvider();
    if (token.isEmpty) {
      emit(state.copyWith(error: 'Not authenticated. Please log in.'));
      return;
    }

    final userMsgId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final agentMsgId = 'agent_${DateTime.now().millisecondsSinceEpoch + 1}';

    final userMessage = ChatMessage(
      id: userMsgId,
      text: event.message,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final initialAgentMessage = ChatMessage(
      id: agentMsgId,
      text: '',
      sender: MessageSender.agent,
      timestamp: DateTime.now(),
      isStreaming: true,
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage)
      ..add(initialAgentMessage);

    emit(state.copyWith(
      messages: updatedMessages,
      isStreaming: true,
      clearError: true,
      activeAgent: event.agent,
    ));

    var assistantText = '';
    var activeSessionId = state.sessionId;
    final activeToolCalls = <ToolCallInfo>[];
    final activeArtifacts = <ArtifactRef>[];

    try {
      final stream = chatRepository.streamTurn(
        message: event.message,
        token: token,
        sessionId: state.sessionId,
        agent: event.agent,
        context: event.context,
      );

      await for (final sseEvent in stream) {
        switch (sseEvent) {
          case SseReadyEvent():
            break;

          case SseSessionEvent(:final sessionId):
            activeSessionId = sessionId;
            emit(state.copyWith(sessionId: sessionId));
            break;

          case SseMessageEvent(:final text, :final isFinal):
            assistantText += text;
            _updateAgentMessage(
              emit,
              agentMsgId: agentMsgId,
              text: assistantText,
              toolCalls: activeToolCalls,
              artifacts: activeArtifacts,
              isStreaming: !isFinal,
            );
            break;

          case SseToolCallEvent(:final id, :final name, :final args):
            final toolCall = ToolCallInfo(
              id: id,
              name: name,
              args: args,
              status: ToolExecutionStatus.invoking,
            );
            activeToolCalls.add(toolCall);
            emit(state.copyWith(currentToolCall: toolCall));
            _updateAgentMessage(
              emit,
              agentMsgId: agentMsgId,
              text: assistantText,
              toolCalls: activeToolCalls,
              artifacts: activeArtifacts,
              isStreaming: true,
            );
            break;

          case SseToolResponseEvent(:final id, :final name, :final response, :final artifact):
            final index = activeToolCalls.indexWhere((t) => t.id == id || t.name == name);
            final updatedTool = ToolCallInfo(
              id: id,
              name: name,
              args: index != -1 ? activeToolCalls[index].args : const {},
              status: ToolExecutionStatus.completed,
              response: response,
              artifact: artifact,
            );

            if (index != -1) {
              activeToolCalls[index] = updatedTool;
            } else {
              activeToolCalls.add(updatedTool);
            }

            if (artifact != null) {
              activeArtifacts.add(artifact);
              // Asynchronously fetch full payload
              unawaited(_fetchFullArtifactPayload(artifact.artifactId));
            }

            emit(state.copyWith(currentToolCall: updatedTool));
            _updateAgentMessage(
              emit,
              agentMsgId: agentMsgId,
              text: assistantText,
              toolCalls: activeToolCalls,
              artifacts: activeArtifacts,
              isStreaming: true,
            );
            break;

          case SseUsageEvent():
            emit(state.copyWith(lastUsage: sseEvent));
            break;

          case SseDoneEvent(:final sessionId):
            activeSessionId = sessionId;
            _updateAgentMessage(
              emit,
              agentMsgId: agentMsgId,
              text: assistantText,
              toolCalls: activeToolCalls,
              artifacts: activeArtifacts,
              isStreaming: false,
            );
            emit(state.copyWith(
              isStreaming: false,
              clearCurrentToolCall: true,
              sessionId: sessionId,
            ));
            break;

          case SseErrorEvent(:final message):
            _updateAgentMessage(
              emit,
              agentMsgId: agentMsgId,
              text: assistantText.isNotEmpty ? assistantText : 'Error: $message',
              toolCalls: activeToolCalls,
              artifacts: activeArtifacts,
              isStreaming: false,
              error: message,
            );
            emit(state.copyWith(
              isStreaming: false,
              clearCurrentToolCall: true,
              error: message,
            ));
            break;
        }
      }
    } catch (e) {
      _updateAgentMessage(
        emit,
        agentMsgId: agentMsgId,
        text: assistantText.isNotEmpty ? assistantText : 'Error: $e',
        toolCalls: activeToolCalls,
        artifacts: activeArtifacts,
        isStreaming: false,
        error: e.toString(),
      );
      emit(state.copyWith(
        isStreaming: false,
        clearCurrentToolCall: true,
        error: e.toString(),
        sessionId: activeSessionId,
      ));
    }
  }

  void _updateAgentMessage(
    Emitter<ChatState> emit, {
    required String agentMsgId,
    required String text,
    required List<ToolCallInfo> toolCalls,
    required List<ArtifactRef> artifacts,
    required bool isStreaming,
    String? error,
  }) {
    final updatedList = state.messages.map((m) {
      if (m.id == agentMsgId) {
        return m.copyWith(
          text: text,
          toolCalls: List.from(toolCalls),
          artifacts: List.from(artifacts),
          isStreaming: isStreaming,
          error: error,
        );
      }
      return m;
    }).toList();

    emit(state.copyWith(messages: updatedList, isStreaming: isStreaming));
  }

  Future<void> _fetchFullArtifactPayload(String artifactId) async {
    final payload = await chatRepository.getArtifact(artifactId);
    if (payload != null && !isClosed) {
      add(ChatArtifactPayloadLoaded(artifactId: artifactId, payload: payload));
    }
  }

  void _onChatArtifactPayloadLoaded(
    ChatArtifactPayloadLoaded event,
    Emitter<ChatState> emit,
  ) {
    final updatedMessages = state.messages.map((msg) {
      final updatedArtifacts = msg.artifacts.map((art) {
        if (art.artifactId == event.artifactId) {
          return art.copyWith(fullPayload: event.payload);
        }
        return art;
      }).toList();
      return msg.copyWith(artifacts: updatedArtifacts);
    }).toList();

    emit(state.copyWith(messages: updatedMessages));
  }

  void _onChatSessionReset(
    ChatSessionReset event,
    Emitter<ChatState> emit,
  ) {
    emit(const ChatState());
  }
}
