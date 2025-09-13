import 'dart:developer';

class Helpers {
  /// Convert dynamic response safely
  static T? cast<T>(dynamic x) => x is T ? x : null;

  /// Format error messages for logs
  static String formatError(Object error) {
    return "[Error] ${error.toString()}";
  }

  /// Debug print wrapper
  static void logDebug(String message, {String tag = "APP"}) {
    log("[$tag] $message");
  }

  /// Retry logic (e.g., network retries)
  static Future<T> retry<T>(
      Future<T> Function() task, {
        int retries = 3,
        Duration delay = const Duration(seconds: 1),
      }) async {
    late Object lastError;
    for (var i = 0; i < retries; i++) {
      try {
        return await task();
      } catch (e) {
        lastError = e;
        await Future.delayed(delay);
      }
    }
    throw lastError;
  }
}
