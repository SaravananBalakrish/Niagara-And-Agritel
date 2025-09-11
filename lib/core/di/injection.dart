import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../flavor/flavor_config.dart';
import '../flavor/flavor_di.dart';

final GetIt sl = GetIt.instance;

/// Initialize dependency graph.
///
/// If [clear] is true the GetIt container will be reset first (useful for tests).
/// This method must be called after FlavorConfig.setup(...) so flavor values are available.
Future<void> init({bool clear = false}) async {
  if (clear) {
    await reset();
  }

  // Ensure FlavorConfig was setup
  try {
    // Accessing instance throws a helpful error if not initialized
    final _ = FlavorConfig.instance;
  } catch (e) {
    throw StateError('FlavorConfig must be initialized before DI. Call FlavorConfig.setup(...) in main.');
  }

  // --------------------------
  // 1) External / third-party
  // --------------------------
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  // SharedPreferences is async to initialize
  if (!sl.isRegistered<SharedPreferences>()) {
    final prefs = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(prefs);
  }

  // Add other external libs (e.g., Dio, Firebase) here...
  // e.g. sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(baseUrl: FlavorConfig.instance.values.apiBaseUrl)));

  // --------------------------
  // 2) Flavor-specific services
  // --------------------------
  // Delegate flavor-specific registrations to flavor_di.dart
  // (registers ApiClient with baseUrl, analytics/crash reporting toggles, etc.)
  registerFlavorDependencies(sl);

  // --------------------------
  // 3) Core / App-wide services
  // --------------------------
  // Example: register an ApiClient implementation that may still depend on flavor values.
  // If you implemented ApiClient in flavor_di, skip or remove below.
  //
  // if (!sl.isRegistered<ApiClient>()) {
  //   sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(FlavorConfig.instance.values.apiBaseUrl));
  // }

  // --------------------------
  // 4) Feature-level registrations
  // --------------------------
  // Register data sources, repositories, usecases, and presentation factories.
  // Keep registrations minimal and prefer interfaces (abstract classes).
  //
  // Example (replace with your concrete types):
  //
  // // Data sources
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(client: sl()));
  //
  // // Repositories
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remote: sl()));
  //
  // // Use cases
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
  //
  // // Blocs / Controllers (use factory so state isn't shared unexpectedly)
  // sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // --------------------------
  // 5) App-level helpers / singletons
  // --------------------------
  // e.g. ErrorHandler, NetworkInfo, Connectivity, Router, etc.

  // Note: keep DI deterministic and avoid registering multiple implementations for the same type
  // unless you intentionally want to override them later (e.g. in tests).
}

/// Reset the GetIt registry. Useful in tests.
///
/// This will unregister everything and release resources. After calling this,
/// call init() again to re-register app dependencies.
Future<void> reset() async {
  // Dispose items that may need explicit cleanup before reset (optional).
  // e.g. if you registered a DB connection or sockets, close them here.

  await sl.reset();
}

/// Helper to register test doubles/overrides quickly in tests.
///
/// Example (inside test setUp):
///   await di.reset();
///   await di.init(); // if you want real registrations first
///   di.sl.registerSingleton<AuthRepository>(MockAuthRepository());
///
/// Or directly register mocks without calling init:
///   di.registerTestOverrides();
void registerTestOverrides() {
  // Common pattern: register no-op analytics, fake network info, etc.
  // Example:
  // if (!sl.isRegistered<AnalyticsService>()) {
  //   sl.registerSingleton<AnalyticsService>(NoOpAnalyticsService());
  // }
}