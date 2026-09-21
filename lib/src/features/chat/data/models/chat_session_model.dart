import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';

/// Data Model for ChatSessionSummary
class ChatSessionModel extends ChatSessionSummary {
  const ChatSessionModel({
    required super.id,
    required super.title,
    super.summary,
    super.agentId,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.totalTokens,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id']?.toString() ?? json['session_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Conversation',
      summary: json['summary']?.toString() ?? '',
      agentId: json['agent_id']?.toString() ?? 'root',
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
    );
  }

  /// Parses the raw messages array from GET /api/chat/sessions/{id}
  static List<ChatMessage> parseMessages(List<dynamic> rawList) {
    final result = <ChatMessage>[];

    List<ToolCallInfo> pendingToolCalls = [];
    List<ArtifactRef> pendingArtifacts = [];

    for (final item in rawList) {
      if (item is! Map<String, dynamic>) continue;

      final role = item['role']?.toString().toLowerCase();
      final text = item['text']?.toString() ?? '';
      final msgId = item['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
      final createdAt = item['created_at'] != null
          ? (DateTime.tryParse(item['created_at'].toString()) ?? DateTime.now())
          : DateTime.now();

      if (role == 'user') {
        result.add(ChatMessage(
          id: msgId,
          text: text,
          sender: MessageSender.user,
          timestamp: createdAt,
        ));
      } else if (role == 'tool') {
        final eventType = item['event_type']?.toString();
        final payload = item['payload'] is Map<String, dynamic> ? item['payload'] as Map<String, dynamic> : <String, dynamic>{};

        if (eventType == 'tool_call') {
          pendingToolCalls.add(ToolCallInfo(
            id: payload['id']?.toString() ?? msgId,
            name: payload['name']?.toString() ?? text.replaceAll('Tool call: ', ''),
            args: payload['args'] is Map<String, dynamic> ? payload['args'] as Map<String, dynamic> : const {},
            status: ToolExecutionStatus.completed,
          ));
        } else if (eventType == 'tool_response') {
          final artifactId = item['artifact_id']?.toString();
          final component = item['component']?.toString();

          ArtifactRef? artifact;
          if (artifactId != null && artifactId.isNotEmpty) {
            artifact = ArtifactRef(
              artifactId: artifactId,
              uiComponent: component ?? 'flight_results',
              summary: payload,
            );
            pendingArtifacts.add(artifact);
          }
        }
      } else if (role == 'assistant') {
        result.add(ChatMessage(
          id: msgId,
          text: text,
          sender: MessageSender.agent,
          timestamp: createdAt,
          toolCalls: List.from(pendingToolCalls),
          artifacts: List.from(pendingArtifacts),
        ));
        pendingToolCalls.clear();
        pendingArtifacts.clear();
      }
    }

    // If any trailing assistant message with tools
    if (pendingToolCalls.isNotEmpty || pendingArtifacts.isNotEmpty) {
      result.add(ChatMessage(
        id: 'trailing_${DateTime.now().millisecondsSinceEpoch}',
        text: '',
        sender: MessageSender.agent,
        timestamp: DateTime.now(),
        toolCalls: List.from(pendingToolCalls),
        artifacts: List.from(pendingArtifacts),
      ));
    }

    return result;
  }
}
