/// Exceptions represent low-level errors thrown by data sources.
/// They will be converted to `Failure` in the repository layer.

/// Thrown when the server responds with an error (HTTP 4xx, 5xx, etc.)
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = "Server Exception", this.statusCode});

  @override
  String toString() => "ServerException: $message (code: $statusCode)";
}

class AuthException implements Exception {
  final String message;
  final String? statusCode;

  AuthException({this.message = "Server Exception", this.statusCode});

  @override
  String toString() => "ServerException: $message (code: $statusCode)";
}

/// Thrown when there is an error with cached/local data.
class CacheException implements Exception {
  final String message;

  CacheException([this.message = "Cache Exception"]);

  @override
  String toString() => "CacheException: $message";
}

/// Thrown when request is cancelled or times out.
class TimeoutException implements Exception {
  final String message;

  TimeoutException([this.message = "Request Timeout"]);

  @override
  String toString() => "TimeoutException: $message";
}

/// Thrown when there is an error related to MQTT communication.
class MqttException implements Exception {
  final String message;
  final int? code;

  MqttException({this.message = "MQTT Exception", this.code});

  @override
  String toString() => "MqttException: $message (code: $code)";
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({this.message = "Unauthorized"});
  @override
  String toString() => "UnauthorizedException: $message";
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);
  @override
  String toString() => "UnexpectedException: $message";
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}

