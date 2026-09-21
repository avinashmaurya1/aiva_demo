enum MessageSender { user, agent, system }

enum ToolExecutionStatus { invoking, completed, failed }

/// Reference to a rich UI artifact returned from tool execution
class ArtifactRef {
  final String artifactId;
  final String uiComponent;
  final String uiDisplay;
  final Map<String, dynamic> summary;
  final Map<String, dynamic>? fullPayload;

  const ArtifactRef({
    required this.artifactId,
    required this.uiComponent,
    this.uiDisplay = 'chat',
    this.summary = const {},
    this.fullPayload,
  });

  ArtifactRef copyWith({
    String? artifactId,
    String? uiComponent,
    String? uiDisplay,
    Map<String, dynamic>? summary,
    Map<String, dynamic>? fullPayload,
  }) {
    return ArtifactRef(
      artifactId: artifactId ?? this.artifactId,
      uiComponent: uiComponent ?? this.uiComponent,
      uiDisplay: uiDisplay ?? this.uiDisplay,
      summary: summary ?? this.summary,
      fullPayload: fullPayload ?? this.fullPayload,
    );
  }
}

/// Represents a tool invocation by the agent
class ToolCallInfo {
  final String id;
  final String name;
  final Map<String, dynamic> args;
  final ToolExecutionStatus status;
  final dynamic response;
  final ArtifactRef? artifact;

  const ToolCallInfo({
    required this.id,
    required this.name,
    this.args = const {},
    this.status = ToolExecutionStatus.invoking,
    this.response,
    this.artifact,
  });

  ToolCallInfo copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? args,
    ToolExecutionStatus? status,
    dynamic response,
    ArtifactRef? artifact,
  }) {
    return ToolCallInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      args: args ?? this.args,
      status: status ?? this.status,
      response: response ?? this.response,
      artifact: artifact ?? this.artifact,
    );
  }
}

/// Represents a conversational chat message in AIVA
class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isStreaming;
  final List<ToolCallInfo> toolCalls;
  final List<ArtifactRef> artifacts;
  final String? error;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isStreaming = false,
    this.toolCalls = const [],
    this.artifacts = const [],
    this.error,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isStreaming,
    List<ToolCallInfo>? toolCalls,
    List<ArtifactRef>? artifacts,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
      toolCalls: toolCalls ?? this.toolCalls,
      artifacts: artifacts ?? this.artifacts,
      error: error ?? this.error,
    );
  }
}
