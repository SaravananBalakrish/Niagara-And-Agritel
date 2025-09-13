/// API-related constants
class ApiConstants {
  static const String baseUrl = "https://api.example.com";
  static const String mqttBroker = "wss://broker.example.com:8083/mqtt";
  static const int mqttKeepAlive = 60;
}

/// Storage keys
class StorageKeys {
  static const String authToken = "AUTH_TOKEN";
  static const String themeMode = "THEME_MODE";
  static const String userCache = "USER_CACHE";
}

/// App-wide enums
enum Environment { dev, staging, prod }
enum ThemeType { light, dark, system }
