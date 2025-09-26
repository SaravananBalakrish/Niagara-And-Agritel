import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/models/user_model.dart';
import '../error/exceptions.dart';
import 'api_urls.dart';
import 'network_info.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;
  final AuthLocalDataSource _authLocalDataSource;
  final NetworkInfo _networkInfo;

  ApiClient({required this.baseUrl, required this.client})
      : _authLocalDataSource = GetIt.instance<AuthLocalDataSource>(),
        _networkInfo = GetIt.instance<NetworkInfo>();

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      if (!await _networkInfo.isConnected) {
        throw NetworkException(message: 'No internet connection');
      }
      final user = await _authLocalDataSource.getCachedUser();
      final mergedHeaders = {
        'Content-Type': 'application/json',
        if (user != null) 'User-Id': user.id,
        // if (user != null && user.accessToken != null) 'Authorization': 'Bearer ${user.accessToken}',
        ...?headers,
      };

      final response = await client
          .get(Uri.parse('$baseUrl$endpoint'), headers: mergedHeaders)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException("GET request to $endpoint timed out");
    }
  }

  // core/services/api_client.dart
  Future<dynamic> post(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    try {
      final user = await _authLocalDataSource.getCachedUser();
      final mergedHeaders = {
        'Content-Type': 'application/json',
        if (user != null) 'User-Id': user.id,
        // if (user != null && user.accessToken != null) 'Authorization': 'Bearer ${user.accessToken}',
        ...?headers,
      };

      final response = await client
          .post(
        Uri.parse('$baseUrl$endpoint'),
        headers: mergedHeaders,
        body: body != null ? jsonEncode(body) : null,
      )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException("POST request to $endpoint timed out");
    } on UnauthorizedException {
      if (endpoint != ApiUrls.loginUrl) {
        // Attempt to refresh Firebase token
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          try {
            final newToken = await firebaseUser.getIdToken(true); // Force refresh
            final user = await _authLocalDataSource.getCachedUser();
            if (user != null) {
              final updatedUser = UserModel(
                id: user.id,
                name: user.name,
                mobile: user.mobile,
                accessToken: user.accessToken,
              );
              await _authLocalDataSource.cacheUser(updatedUser);

              // Retry the request
              final mergedHeaders = {
                'Content-Type': 'application/json',
                'User-Id': user.id,
                'Authorization': 'Bearer $newToken',
                ...?headers,
              };

              final retryResponse = await client
                  .post(
                Uri.parse('$baseUrl$endpoint'),
                headers: mergedHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
                  .timeout(const Duration(seconds: 15));

              return _handleResponse(retryResponse);
            }
          } catch (e) {
            await _authLocalDataSource.clearUser();
            throw UnauthorizedException(message: "Token refresh failed: $e");
          }
        }
        throw UnauthorizedException(message: "Unauthorized: No valid user session");
      }
      throw UnauthorizedException(message: "Login failed");
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? response.body : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body != null ? jsonDecode(body) : null;
    } else if (statusCode == 401) {
      // Handle unauthorized access (e.g., token expired)
      GetIt.instance<AuthLocalDataSource>().clearUser();
      throw UnauthorizedException(message: body ?? "Unauthorized");
    } else if (statusCode == 500) {
      throw ServerException(message: body ?? "Internal Server Error", statusCode: 500);
    } else {
      throw UnexpectedException("Error $statusCode: $body");
    }
  }
}