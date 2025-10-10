import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../my_device/domain/entities/controller_entity.dart';
import '../../domain/entities/controller_entity.dart';
import '../../domain/usecases/fetch_controllers_usecase.dart';
import '../../domain/usecases/fetch_dashboard_groups_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDashboardGroups fetchDashboardGroups;
  final FetchControllers fetchControllers;

  DashboardBloc({required this.fetchDashboardGroups, required this.fetchControllers}) : super(DashboardInitial()) {
    on<FetchDashboardGroupsEvent>((event, emit) async {
      emit(DashboardLoading());
      final result = await fetchDashboardGroups(DashboardGroupsParams(event.userId));

      result.fold(
        (failure) => emit(DashboardError(message: failure.message)),
        (groups) {
          emit(DashboardGroupsLoaded(groups: groups));

          if (groups.isNotEmpty) {
            add(FetchControllersEvent(event.userId, groups[0].userGroupId));
          }
        },
      );
    });

    on<FetchControllersEvent>((event, emit) async {
      if (state is DashboardGroupsLoaded) {
        final currentState = state as DashboardGroupsLoaded;
        final result = await fetchControllers(UserGroupParams(event.userId, event.groupId));

        final updatedControllers = Map<int, List<ControllerEntity>>.from(currentState.groupControllers);
        result.fold(
          (failure) => emit(DashboardError(message: failure.message)),
          (controllers) {
            updatedControllers[event.groupId] = controllers;
            emit(DashboardGroupsLoaded(
              groups: currentState.groups,
              groupControllers: updatedControllers,
            ));
          },
        );
      }
    });

    on<SelectGroupEvent>((event, emit) async {
      if (state is DashboardGroupsLoaded) {
        final currentState = state as DashboardGroupsLoaded;
        // Reset controller index for new group
        final newState = currentState.copyWith(
          selectedGroupId: event.groupId,
          selectedControllerIndex: null, // Reset to null; UI will default to 0
        );
        emit(newState);

        // Fetch controllers if not loaded
        final group = currentState.groups.firstWhere((g) => g.userGroupId == event.groupId, orElse: () => throw Exception('Group not found'));
        final userId = group.userId;
        if (!currentState.groupControllers.containsKey(event.groupId)) {
          final result = await fetchControllers(UserGroupParams(userId, event.groupId));
          result.fold(
            (failure) => emit(DashboardError(message: failure.message)),
            (controllers) {
              final updatedControllers = Map<int, List<ControllerEntity>>.from(newState.groupControllers);
              updatedControllers[event.groupId] = controllers;
              // Optionally auto-select first controller here
              final updatedState = newState.copyWith(
                groupControllers: updatedControllers,
                selectedControllerIndex: controllers.isNotEmpty ? 0 : null,
              );
              emit(updatedState);
            },
          );
        } else {
          // If already loaded, auto-select first
          final controllers = currentState.groupControllers[event.groupId] ?? [];
          final updatedState = newState.copyWith(
            selectedControllerIndex: controllers.isNotEmpty ? 0 : null,
          );
          emit(updatedState);
        }
      }
    });

    on<SelectControllerEvent>((event, emit) async {
      if (state is DashboardGroupsLoaded) {
        final currentState = state as DashboardGroupsLoaded;
        if (currentState.selectedGroupId != null &&
            (currentState.groupControllers[currentState.selectedGroupId!]?.length ?? 0) > event.controllerIndex) {
          emit(currentState.copyWith(selectedControllerIndex: event.controllerIndex));
        }
      }
    });
  }
}