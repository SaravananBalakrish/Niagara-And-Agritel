import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/fetch_controllers_usecase.dart';
import '../../features/dashboard/domain/usecases/fetch_dashboard_groups_usecase.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../flavor/flavor_config.dart';
import '../flavor/flavor_di.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../services/api_client.dart';
import '../services/get_credentials.dart';
import '../services/mqtt_service.dart';
import '../services/network_info.dart';
import '../services/notification_service.dart';
import '../theme/theme_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> init({bool clear = false, SharedPreferences? prefs, http.Client? httpClient}) async {
  if (clear) await reset();

  // Ensure FlavorConfig was setup
  try {
    final _ = FlavorConfig.instance;
  } catch (e) {
    throw StateError('FlavorConfig must be initialized before DI. Call FlavorConfig.setup(...) in main.');
  }

  // External / third-party
  sl.registerLazySingleton<http.Client>(() => httpClient ?? http.Client());

  final actualPrefs = prefs ?? await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(actualPrefs);

 sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));

  sl.registerLazySingleton<MqttService>(
        () => MqttService(
      broker: 'broker.hivemq.com',
      port: 1883,
      clientIdentifier: 'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    ),
  );

  // Flavor-specific services
  registerFlavorDependencies(sl);

  // Core services
  sl.registerLazySingleton(() => ThemeProvider());

  // Feature: Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(prefs: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(apiClient: ApiClient(baseUrl: FlavorConfig.instance.values.apiBaseUrl, client: sl())),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remote: sl(), local: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginWithPassword(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => CheckPhoneNumber(sl()));

  // Bloc
  sl.registerLazySingleton(() => AuthBloc(
    loginWithPassword: sl(),
    sendOtp: sl(),
    verifyOtp: sl(),
    logout: sl(),
    checkPhoneNumber: sl()
  ));

  sl.registerSingleton<NotificationService>(NotificationService());

  sl.registerLazySingleton<SomeService>(() => SomeService());

  // Dashboard Feature
  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remote: sl()));
  sl.registerLazySingleton(() => FetchDashboardGroups(sl()));
  sl.registerLazySingleton(() => FetchControllers(sl()));
  sl.registerLazySingleton(() => DashboardBloc(fetchDashboardGroups: sl(), fetchControllers: sl()));
}

// Reset all
Future<void> reset() async {
  await sl.reset();
}