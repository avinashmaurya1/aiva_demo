import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:aiva_ai_agent/src/core/constants/api_endpoints.dart';
import 'package:aiva_ai_agent/src/core/network/sse_client.dart';

void main() {
  test('Live login & SSE chat stream verification against AgenticBox backend', () async {
    // 1. Authenticate to get real JWT token
    final loginRes = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'companyId': 'qlabs12345',
        'accountNo': '',
        'userName': 'AnujAI',
        'password': '07KDJHRU',
        'source': 'SBT',
      }),
    );

    expect(loginRes.statusCode, 200);
    final loginData = jsonDecode(loginRes.body)['data'];
    final accessToken = loginData['accessToken'] as String;

    // ignore: avoid_print
    print('Authenticated! Token: ${accessToken.substring(0, 30)}...');

    // 2. Open SSE chat stream
    final sseClient = SseClient();
    final stream = sseClient.streamEvents(
      url: ApiEndpoints.chatStream,
      token: accessToken,
      body: {
        'message': 'Hi, find flights from DEL to BOM for tomorrow',
        'agent': 'root',
      },
    );

    // ignore: avoid_print
    print('\nStreaming live events from /chat/stream...');
    final events = <SseRawEvent>[];

    await for (final event in stream) {
      events.add(event);
      // ignore: avoid_print
      print('>>> [Event: ${event.event}] Data: ${event.data}');
      if (event.event == 'done' || event.event == 'error') {
        break;
      }
    }

    expect(events, isNotEmpty);
    // ignore: avoid_print
    print('\nTotal received events: ${events.length}');
  });
}
