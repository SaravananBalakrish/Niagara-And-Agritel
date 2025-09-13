import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../network/api_client.dart';
import 'flavor_config.dart';

abstract class ExampleService {
  String get info;
}

class ExampleServiceImpl implements ExampleService {
  final String flavorName;
  ExampleServiceImpl(this.flavorName);
  @override
  String get info => 'Service for $flavorName';
}

void registerFlavorDependencies(GetIt sl) {
  final cfg = FlavorConfig.instance;

  // --------------------------
  // Example flavor-aware service
  // --------------------------
  sl.registerLazySingleton<ExampleService>(
          () => ExampleServiceImpl(cfg.values.displayName));

  // --------------------------
  // Flavor-aware ApiClient
  // --------------------------
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(() => ApiClient(
      baseUrl: cfg.values.apiBaseUrl,
      client: sl<http.Client>(),
    ));
  }

  // --------------------------
  // Optional: other flavor-specific services
  // --------------------------
  // e.g., AnalyticsService, CrashlyticsService
}
