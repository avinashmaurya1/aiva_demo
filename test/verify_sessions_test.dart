import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:aiva_ai_agent/src/core/constants/api_endpoints.dart';

void main() {
  test('Live session list and detail verification against AgenticBox', () async {
    // 1. Authenticate to get token
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

    // 2. Fetch sessions list
    // ignore: avoid_print
    print('Fetching sessions list from ${ApiEndpoints.chatSessions}...');
    final sessionsRes = await http.get(
      Uri.parse(ApiEndpoints.chatSessions),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    // ignore: avoid_print
    print('Sessions status code: ${sessionsRes.statusCode}');
    // ignore: avoid_print
    print('Sessions response: ${sessionsRes.body}');

    expect(sessionsRes.statusCode, 200);
    final dynamic decodedSessions = jsonDecode(sessionsRes.body);
    // ignore: avoid_print
    print('Decoded sessions: $decodedSessions');

    // 3. If sessions exist, fetch detail of first session
    List list = [];
    if (decodedSessions is List) {
      list = decodedSessions;
    } else if (decodedSessions is Map && decodedSessions['data'] is List) {
      list = decodedSessions['data'];
    }

    if (list.isNotEmpty) {
      final firstSessionId = list.first['id'] ?? list.first['session_id'];
      if (firstSessionId != null) {
        // ignore: avoid_print
        print('\nFetching session detail for $firstSessionId...');
        final detailRes = await http.get(
          Uri.parse(ApiEndpoints.sessionById(firstSessionId.toString())),
          headers: {'Authorization': 'Bearer $accessToken'},
        );
        // ignore: avoid_print
        print('Detail status code: ${detailRes.statusCode}');
        // ignore: avoid_print
        print('Detail response: ${detailRes.body}');
      }
    }
  });
}
