import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;

  ApiClient({required this.baseUrl, required this.client});

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl$endpoint'), headers: headers)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException("GET request to $endpoint timed out");
    }
  }

  Future<dynamic> post(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    try {
      final response = await client
          .post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException("POST request to $endpoint timed out");
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? response.body : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body != null ? jsonDecode(body) : null;
    } else if (statusCode == 401) {
      throw UnauthorizedException(message: body ?? "Unauthorized");
    } else if (statusCode == 500) {
      throw ServerException(message: body ?? "Internal Server Error", statusCode: 500);
    } else {
      throw UnexpectedException("Error $statusCode: $body");
    }
  }
}
