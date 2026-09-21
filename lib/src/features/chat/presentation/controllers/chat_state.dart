import '../../domain/entities/chat_message.dart';
import '../../domain/entities/sse_event.dart';

/// Immutable State for ChatBloc
class ChatState {
  final List<ChatMessage> messages;
  final String? sessionId;
  final String activeAgent;
  final bool isStreaming;
  final ToolCallInfo? currentToolCall;
  final String? error;
  final SseUsageEvent? lastUsage;

  const ChatState({
    this.messages = const [],
    this.sessionId,
    this.activeAgent = 'root',
    this.isStreaming = false,
    this.currentToolCall,
    this.error,
    this.lastUsage,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? sessionId,
    String? activeAgent,
    bool? isStreaming,
    ToolCallInfo? currentToolCall,
    bool clearCurrentToolCall = false,
    String? error,
    bool clearError = false,
    SseUsageEvent? lastUsage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      activeAgent: activeAgent ?? this.activeAgent,
      isStreaming: isStreaming ?? this.isStreaming,
      currentToolCall: clearCurrentToolCall ? null : (currentToolCall ?? this.currentToolCall),
      error: clearError ? null : (error ?? this.error),
      lastUsage: lastUsage ?? this.lastUsage,
    );
  }
}
