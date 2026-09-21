import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Live login verification test against AgenticBox backend', () async {
    final url = Uri.parse('https://ai-uat.quadlabs.net/api/auth/login');
    final payload = {
      'companyId': 'qlabs12345',
      'accountNo': '',
      'userName': 'AnujAI',
      'password': '07KDJHRU',
      'source': 'SBT',
    };

    // ignore: avoid_print
    print('Sending login request to $url...');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    // ignore: avoid_print
    print('Login Status Code: ${response.statusCode}');
    // ignore: avoid_print
    print('Login Response Body: ${response.body}');

    expect(response.statusCode, 200);

    final decoded = jsonDecode(response.body);
    expect(decoded['success'], true);
    final data = decoded['data'];
    expect(data, isNotNull);
    expect(data['accessToken'], isNotNull);

    // ignore: avoid_print
    print('\n>>> LOGIN SUCCESSFUL! <<<');
    // ignore: avoid_print
    print('Access Token: ${data['accessToken'].toString().substring(0, 40)}...');
    // ignore: avoid_print
    print('Travog Base URL: ${data['travogBaseUrl']}');

    // Test bootstrap
    if (data['travogBaseUrl'] != null) {
      final bootstrapUrl = Uri.parse(
        'https://ai-uat.quadlabs.net/api/auth/bootstrap?travogBaseUrl=${data['travogBaseUrl']}',
      );
      // ignore: avoid_print
      print('\nTesting bootstrap endpoint: $bootstrapUrl...');
      final bootRes = await http.get(
        bootstrapUrl,
        headers: {'Authorization': 'Bearer ${data['accessToken']}'},
      );
      // ignore: avoid_print
      print('Bootstrap Status: ${bootRes.statusCode}');
      // ignore: avoid_print
      print('Bootstrap Body: ${bootRes.body}');
      expect(bootRes.statusCode, 200);
    }
  });
}
