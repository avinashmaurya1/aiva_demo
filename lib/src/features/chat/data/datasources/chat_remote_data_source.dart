import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/sse_client.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/sse_event.dart';

abstract class ChatRemoteDataSource {
  Stream<SseEvent> streamChatTurn({
    required String message,
    required String token,
    String? sessionId,
    String agent = 'root',
    Map<String, dynamic>? context,
  });

  Future<Map<String, dynamic>?> fetchArtifact(String artifactId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SseClient _sseClient;
  final ApiClient _apiClient;

  ChatRemoteDataSourceImpl({
    SseClient? sseClient,
    ApiClient? apiClient,
  })  : _sseClient = sseClient ?? SseClient(),
        _apiClient = apiClient ?? ApiClient();

  @override
  Stream<SseEvent> streamChatTurn({
    required String message,
    required String token,
    String? sessionId,
    String agent = 'root',
    Map<String, dynamic>? context,
  }) async* {
    final body = <String, dynamic>{
      'message': message,
      'agent': agent,
      'context': context ?? <String, dynamic>{},
    };
    if (sessionId != null && sessionId.isNotEmpty) {
      body['session_id'] = sessionId;
    }

    final rawStream = _sseClient.streamEvents(
      url: ApiEndpoints.chatStream,
      token: token,
      body: body,
    );

    await for (final rawEvent in rawStream) {
      final event = _mapRawEventToEntity(rawEvent);
      if (event != null) {
        yield event;
      }
    }
  }

  SseEvent? _mapRawEventToEntity(SseRawEvent raw) {
    final data = raw.data;
    switch (raw.event) {
      case 'ready':
        return SseReadyEvent(userId: data['user_id']?.toString());

      case 'session':
        return SseSessionEvent(
          sessionId: data['session_id']?.toString() ?? '',
          agent: data['agent']?.toString() ?? 'root',
        );

      case 'message':
        return SseMessageEvent(
          text: data['text']?.toString() ?? '',
          isFinal: data['final'] == true,
          isRecovery: data['recovery'] == true,
        );

      case 'tool_call':
        return SseToolCallEvent(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? '',
          args: data['args'] is Map<String, dynamic>
              ? data['args'] as Map<String, dynamic>
              : const {},
        );

      case 'tool_response':
        final artifact = _findArtifactEnvelope(data);
        return SseToolResponseEvent(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? '',
          response: data['response'],
          artifact: artifact,
        );

      case 'usage':
        return SseUsageEvent(
          promptTokens: (data['prompt_tokens'] as num?)?.toInt() ?? 0,
          completionTokens: (data['completion_tokens'] as num?)?.toInt() ?? 0,
          totalTokens: (data['total_tokens'] as num?)?.toInt() ?? 0,
        );

      case 'done':
        return SseDoneEvent(
          sessionId: data['session_id']?.toString() ?? '',
          isRecovery: data['recovery'] == true,
        );

      case 'error':
        return SseErrorEvent(
          message: data['message']?.toString() ?? 'Unknown chat error',
          sessionId: data['session_id']?.toString(),
        );

      default:
        return null;
    }
  }

  /// Recursively walks JSON object looking for ui_component and artifact_id
  ArtifactRef? _findArtifactEnvelope(dynamic value) {
    if (value is Map<String, dynamic>) {
      if ((value['type'] == 'ui_component' || value['ui_component'] != null) &&
          value['artifact_id'] != null) {
        return ArtifactRef(
          artifactId: value['artifact_id'].toString(),
          uiComponent: value['ui_component']?.toString() ?? 'generic',
          uiDisplay: value['ui_display']?.toString() ?? 'chat',
          summary: value['summary'] is Map<String, dynamic>
              ? value['summary'] as Map<String, dynamic>
              : (value['search_request'] is Map<String, dynamic>
                  ? value['search_request'] as Map<String, dynamic>
                  : value),
        );
      }
      for (final child in value.values) {
        final found = _findArtifactEnvelope(child);
        if (found != null) return found;
      }
    } else if (value is List) {
      for (final item in value) {
        final found = _findArtifactEnvelope(item);
        if (found != null) return found;
      }
    }
    return null;
  }


  @override
  Future<Map<String, dynamic>?> fetchArtifact(String artifactId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.artifactById(artifactId));
      return response;
    } catch (_) {
      return null;
    }
  }
}
