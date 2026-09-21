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

/// Fetches session history list
class ChatSessionsFetchRequested extends ChatEvent {
  const ChatSessionsFetchRequested();
}

/// User selected a past session from history drawer
class ChatSessionSelected extends ChatEvent {
  final String sessionId;

  const ChatSessionSelected(this.sessionId);
}

/// Starts a new conversation (resets active session and messages)
class ChatNewSessionRequested extends ChatEvent {
  const ChatNewSessionRequested();
}

/// Clears all past sessions
class ChatAllSessionsDeleteRequested extends ChatEvent {
  const ChatAllSessionsDeleteRequested();
}

/// Legacy alias
class ChatSessionReset extends ChatEvent {
  const ChatSessionReset();
}
