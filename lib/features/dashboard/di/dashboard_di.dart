import '../../../core/di/injection.dart';
import '../../mqtt/utils/mqtt_message_helper.dart';
import '../domain/dashboard_domain.dart';
import '../data/dashboard_data.dart';
import '../presentation/bloc/dashboard_bloc.dart';
import '../utils/dashboard_dispatcher.dart';

void initDashboardDependencies() {
// Dashboard Feature
  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(remote: sl()));
  sl.registerLazySingleton(() => FetchDashboardGroups(sl()));
  sl.registerLazySingleton(() => FetchControllers(sl()));
  sl.registerLazySingleton(() => DashboardBloc(fetchDashboardGroups: sl(), fetchControllers: sl(), mqttBloc: sl()));

  sl.registerLazySingleton<MessageDispatcher>(() => DashboardMessageDispatcher(dashboardBloc: sl<DashboardBloc>()));
}