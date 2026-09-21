/// Events for ChatBloc
sealed class ChatEvent {
  const ChatEvent();
}

/// User sent a new message turn
class ChatTurnSubmitted extends ChatEvent {
  final String message;
  final String agent;
  final Map<String, dynamic>? context;

  const ChatTurnSubmitted({
    required this.message,
    this.agent = 'root',
    this.context,
  });
}

/// Loaded complete payload for an artifact ID
class ChatArtifactPayloadLoaded extends ChatEvent {
  final String artifactId;
  final Map<String, dynamic> payload;

  const ChatArtifactPayloadLoaded({
    required this.artifactId,
    required this.payload,
  });
}

/// Clears current conversation & resets session
class ChatSessionReset extends ChatEvent {
  const ChatSessionReset();
}
