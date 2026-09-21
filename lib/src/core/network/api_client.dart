import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

/// Clean HTTP ApiClient with Bearer token authentication support
class ApiClient {
  final http.Client _httpClient;
  String? _bearerToken;

  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  /// Updates or sets the active Bearer token
  void setToken(String? token) {
    _bearerToken = token;
  }

  /// Gets current active Bearer token
  String? get token => _bearerToken;

  Map<String, String> _buildHeaders([Map<String, String>? customHeaders]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_bearerToken != null && _bearerToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  /// Sends POST request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(url),
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } on SocketException {
      throw const ServerException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is AuthException) rethrow;
      throw ServerException('Request failed: $e');
    }
  }

  /// Sends GET request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: _buildHeaders(headers),
      );
      return _handleResponse(response);
    } on SocketException {
      throw const ServerException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is AuthException) rethrow;
      throw ServerException('Request failed: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = {'detail': response.body};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    final errorMessage = decoded is Map<String, dynamic>
        ? (decoded['message'] ?? decoded['detail'] ?? 'An error occurred (${response.statusCode})')
        : 'Request failed with status: ${response.statusCode}';

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException(errorMessage.toString(), statusCode: response.statusCode);
    }

    throw ServerException(errorMessage.toString(), statusCode: response.statusCode);
  }

  /// Closes client
  void close() {
    _httpClient.close();
  }
}
