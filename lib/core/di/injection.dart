import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:niagara_smart_drip_irrigation/features/side_drawer/data/datasources/group_data_sources.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/data/repositories/fetch_group_repository.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/repositories/fetch_group_repository_impl.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/usecases/group_fetching_usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/bloc/group_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/fetch_controllers_usecase.dart';
import '../../features/dashboard/domain/usecases/fetch_dashboard_groups_usecase.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/utils/dashboard_dispatcher.dart';
import '../../features/mqtt/presentation/bloc/mqtt_bloc.dart';
import '../../features/mqtt/utils/mqtt_message_helper.dart';
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
      broker: FlavorConfig.instance.values.broker,
      port: 1883,
      clientIdentifier: 'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      userName: FlavorConfig.instance.values.userName,
      password: FlavorConfig.instance.values.password,
    ),
  );

  //Register MqttBloc after MqttService
  sl.registerLazySingleton<MqttBloc>(() => MqttBloc(mqttService: sl<MqttService>()));

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
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

  // Bloc
  sl.registerLazySingleton(() => AuthBloc(
    loginWithPassword: sl(),
    sendOtp: sl(),
    verifyOtp: sl(),
    logout: sl(),
    checkPhoneNumber: sl(),
    signUp: sl(),
    updateProfile: sl(),
  ));

  sl.registerSingleton<NotificationService>(NotificationService());

  sl.registerLazySingleton<SomeService>(() => SomeService());

  // Dashboard Feature
  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remote: sl()));
  sl.registerLazySingleton(() => FetchDashboardGroups(sl()));
  sl.registerLazySingleton(() => FetchControllers(sl()));
  sl.registerLazySingleton(() => DashboardBloc(fetchDashboardGroups: sl(), fetchControllers: sl(), mqttBloc: sl()));

  sl.registerLazySingleton<MessageDispatcher>(() => DashboardMessageDispatcher(dashboardBloc: sl<DashboardBloc>()));
  
  // AppDrawer Feature
  sl.registerLazySingleton<GroupDataSources>(() => GroupDataSourcesImpl(apiClient: sl()));
  sl.registerLazySingleton<FetchGroupRepository>(() => FetchGroupRepositoryImpl(groupDataSources: sl()));
  sl.registerLazySingleton(() => GroupFetchingUsecase(sl()));
  sl.registerLazySingleton(() => GroupBloc(groupFetchingUsecase: sl()));
}

// Reset all
Future<void> reset() async {
  await sl.reset();
}