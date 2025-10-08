import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fetch_dashboard_groups_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDashboardGroups fetchDashboardGroups;

  DashboardBloc({required this.fetchDashboardGroups}) : super(DashboardInitial()) {
    on<FetchDashboardGroupsEvent>((event, emit) async {
      emit(DashboardLoading());
      final result = await fetchDashboardGroups(DashboardGroupsParams(event.userId));
      result.fold(
            (failure) => emit(DashboardError(message: failure.message)),
            (groups) => emit(DashboardGroupsLoaded(groups: groups)),
      );
    });
  }
}