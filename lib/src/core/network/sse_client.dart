import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

/// Raw SSE Event containing event type and JSON payload data
class SseRawEvent {
  final String event;
  final Map<String, dynamic> data;

  const SseRawEvent({required this.event, required this.data});

  @override
  String toString() => 'SseRawEvent(event: $event, data: $data)';
}

/// Real-time Server-Sent Events (SSE) Client for AgenticBox
class SseClient {
  final http.Client _httpClient;

  SseClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  /// Streams events from an SSE endpoint using HTTP POST
  Stream<SseRawEvent> streamEvents({
    required String url,
    required String token,
    required Map<String, dynamic> body,
    Map<String, String>? extraHeaders,
  }) async* {
    final uri = Uri.parse(url);
    final request = http.Request('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
    });

    if (extraHeaders != null) {
      request.headers.addAll(extraHeaders);
    }

    request.body = jsonEncode(body);

    http.StreamedResponse response;
    try {
      response = await _httpClient.send(request);
    } on SocketException {
      throw const ServerException('No internet connection for live streaming');
    } catch (e) {
      throw ServerException('Failed to open SSE stream: $e');
    }

    if (response.statusCode != 200) {
      final errorBody = await response.stream.bytesToString();
      String msg = 'SSE request failed (${response.statusCode})';
      try {
        final decoded = jsonDecode(errorBody);
        if (decoded is Map && (decoded['detail'] != null || decoded['message'] != null)) {
          msg = decoded['detail'] ?? decoded['message'];
        }
      } catch (_) {}

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw AuthException(msg, statusCode: response.statusCode);
      }
      throw ServerException(msg, statusCode: response.statusCode);
    }

    String buffer = '';

    await for (final chunk in response.stream.transform(utf8.decoder)) {
      buffer += chunk;

      // SSE frames are delimited by double newlines (\n\n or \r\n\r\n)
      final frames = buffer.split(RegExp(r'\r?\n\r?\n'));
      buffer = frames.removeLast(); // Keep incomplete tail in buffer

      for (final frame in frames) {
        if (frame.trim().isEmpty) continue;

        String? eventType;
        String? dataString;

        final lines = frame.split(RegExp(r'\r?\n'));
        for (final line in lines) {
          if (line.startsWith('event:')) {
            eventType = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            dataString = line.substring(5).trim();
          }
        }

        if (eventType != null && dataString != null) {
          try {
            final dynamic parsed = jsonDecode(dataString);
            final dataMap = parsed is Map<String, dynamic>
                ? parsed
                : <String, dynamic>{'value': parsed};
            yield SseRawEvent(event: eventType, data: dataMap);
          } catch (_) {
            yield SseRawEvent(
              event: eventType,
              data: {'raw': dataString},
            );
          }
        }
      }
    }

    // Process any remaining tail in buffer if valid
    if (buffer.trim().isNotEmpty) {
      String? eventType;
      String? dataString;
      final lines = buffer.split(RegExp(r'\r?\n'));
      for (final line in lines) {
        if (line.startsWith('event:')) eventType = line.substring(6).trim();
        if (line.startsWith('data:')) dataString = line.substring(5).trim();
      }
      if (eventType != null && dataString != null) {
        try {
          final dynamic parsed = jsonDecode(dataString);
          final dataMap = parsed is Map<String, dynamic>
              ? parsed
              : <String, dynamic>{'value': parsed};
          yield SseRawEvent(event: eventType, data: dataMap);
        } catch (_) {}
      }
    }
  }

  /// Closes client
  void close() {
    _httpClient.close();
  }
}
