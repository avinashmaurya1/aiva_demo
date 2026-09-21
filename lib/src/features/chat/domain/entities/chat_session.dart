/// Domain Entity for Chat Session Summary
class ChatSessionSummary {
  final String id;
  final String title;
  final String summary;
  final String agentId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int totalTokens;

  const ChatSessionSummary({
    required this.id,
    required this.title,
    this.summary = '',
    this.agentId = 'root',
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    this.totalTokens = 0,
  });

  @override
  String toString() => 'ChatSessionSummary(id: $id, title: $title, agentId: $agentId)';
}
