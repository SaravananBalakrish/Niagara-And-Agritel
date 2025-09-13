import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../flavor/flavor_config.dart';
import '../flavor/flavor_di.dart';
import '../network/api_client.dart';
import '../network/mqtt_service.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../theme/theme_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> init({bool clear = false}) async {
  if (clear) await reset();

  // Ensure FlavorConfig was setup
  try {
    final _ = FlavorConfig.instance;
  } catch (e) {
    throw StateError('FlavorConfig must be initialized before DI. Call FlavorConfig.setup(...) in main.');
  }

  // --------------------------
  // 1) External / third-party
  // --------------------------
  sl.registerLazySingleton<http.Client>(() => http.Client());

  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));

  sl.registerLazySingleton<MqttService>(
        () => MqttService(
      broker: 'broker.hivemq.com',
      port: 1883,
      clientIdentifier: 'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    ),
  );

  // --------------------------
  // 2) Flavor-specific services
  // --------------------------
  registerFlavorDependencies(sl);

  // --------------------------
  // 3) Core services
  // --------------------------
  sl.registerLazySingleton(() => ThemeProvider());

  // --------------------------
  // 4) Feature: Auth
  // --------------------------
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(prefs: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(apiClient: ApiClient(baseUrl: FlavorConfig.instance.values.apiBaseUrl, client: sl())),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remote: sl(), local: sl()),
  );

  // Use case
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
}

// Reset all
Future<void> reset() async {
  await sl.reset();
}
