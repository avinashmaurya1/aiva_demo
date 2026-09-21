import 'chat_message.dart';

/// Sealed class representing all strongly typed events in AgenticBox SSE stream
sealed class SseEvent {
  const SseEvent();
}

class SseReadyEvent extends SseEvent {
  final String? userId;
  const SseReadyEvent({this.userId});
}

class SseSessionEvent extends SseEvent {
  final String sessionId;
  final String agent;
  const SseSessionEvent({required this.sessionId, required this.agent});
}

class SseMessageEvent extends SseEvent {
  final String text;
  final bool isFinal;
  final bool isRecovery;

  const SseMessageEvent({
    required this.text,
    this.isFinal = false,
    this.isRecovery = false,
  });
}

class SseToolCallEvent extends SseEvent {
  final String id;
  final String name;
  final Map<String, dynamic> args;

  const SseToolCallEvent({
    required this.id,
    required this.name,
    this.args = const {},
  });
}

class SseToolResponseEvent extends SseEvent {
  final String id;
  final String name;
  final dynamic response;
  final ArtifactRef? artifact;

  const SseToolResponseEvent({
    required this.id,
    required this.name,
    this.response,
    this.artifact,
  });
}

class SseUsageEvent extends SseEvent {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  const SseUsageEvent({
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
  });
}

class SseDoneEvent extends SseEvent {
  final String sessionId;
  final bool isRecovery;

  const SseDoneEvent({
    required this.sessionId,
    this.isRecovery = false,
  });
}

class SseErrorEvent extends SseEvent {
  final String message;
  final String? sessionId;

  const SseErrorEvent({
    required this.message,
    this.sessionId,
  });
}
