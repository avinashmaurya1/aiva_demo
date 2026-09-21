import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/entities/sse_event.dart';

/// Immutable State for ChatBloc with session history support
class ChatState {
  final List<ChatMessage> messages;
  final String? sessionId;
  final String activeAgent;
  final bool isStreaming;
  final ToolCallInfo? currentToolCall;
  final String? error;
  final SseUsageEvent? lastUsage;

  // Session History State
  final List<ChatSessionSummary> sessions;
  final bool isLoadingSessions;
  final bool isLoadingHistory;

  const ChatState({
    this.messages = const [],
    this.sessionId,
    this.activeAgent = 'root',
    this.isStreaming = false,
    this.currentToolCall,
    this.error,
    this.lastUsage,
    this.sessions = const [],
    this.isLoadingSessions = false,
    this.isLoadingHistory = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? sessionId,
    bool clearSessionId = false,
    String? activeAgent,
    bool? isStreaming,
    ToolCallInfo? currentToolCall,
    bool clearCurrentToolCall = false,
    String? error,
    bool clearError = false,
    SseUsageEvent? lastUsage,
    List<ChatSessionSummary>? sessions,
    bool? isLoadingSessions,
    bool? isLoadingHistory,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      sessionId: clearSessionId ? null : (sessionId ?? this.sessionId),
      activeAgent: activeAgent ?? this.activeAgent,
      isStreaming: isStreaming ?? this.isStreaming,
      currentToolCall: clearCurrentToolCall ? null : (currentToolCall ?? this.currentToolCall),
      error: clearError ? null : (error ?? this.error),
      lastUsage: lastUsage ?? this.lastUsage,
      sessions: sessions ?? this.sessions,
      isLoadingSessions: isLoadingSessions ?? this.isLoadingSessions,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
    );
  }
}
