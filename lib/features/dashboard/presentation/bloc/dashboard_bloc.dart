import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../mqtt/presentation/bloc/mqtt_bloc.dart';
import '../../../mqtt/presentation/bloc/mqtt_event.dart';
import '../../data/models/controller_model.dart';
import '../../domain/entities/controller_entity.dart';
import '../../domain/usecases/fetch_controllers_usecase.dart';
import '../../domain/usecases/fetch_dashboard_groups_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDashboardGroups fetchDashboardGroups;
  final FetchControllers fetchControllers;
  final MqttBloc mqttBloc;

  DashboardBloc({
    required this.fetchDashboardGroups,
    required this.fetchControllers,
    required this.mqttBloc,
  }) : super(DashboardInitial()) {
    on<FetchDashboardGroupsEvent>((event, emit) async {
      emit(DashboardLoading());
      final result = await fetchDashboardGroups(DashboardGroupsParams(event.userId));

      result.fold(
        (failure) => emit(DashboardError(message: failure.message)),
        (groups) {
          emit(DashboardGroupsLoaded(groups: groups, groupControllers: {}));

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
            if (controllers.isNotEmpty) {
              mqttBloc.add(SubscribeMqttEvent(controllers[0].deviceId));
            }
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
              // Subscribe to the first controller's topic after successful fetch
              if (controllers.isNotEmpty) {
                mqttBloc.add(SubscribeMqttEvent(controllers[0].deviceId));
              }
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
          // Subscribe to the first controller's topic
          if (controllers.isNotEmpty) {
            mqttBloc.add(SubscribeMqttEvent(controllers[0].deviceId));
          }
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
          final controllers = currentState.groupControllers[currentState.selectedGroupId!] ?? [];
          final selectedController = controllers[event.controllerIndex];
          // Subscribe to the selected controller's topic
          mqttBloc.add(SubscribeMqttEvent(selectedController.deviceId));
          emit(currentState.copyWith(selectedControllerIndex: event.controllerIndex));
        }
      }
    });

    on<ResetDashboardSelectionEvent>((event, emit) async {
      if (state is DashboardGroupsLoaded) {
        final currentState = state as DashboardGroupsLoaded;
        emit(currentState.copyWith(
          selectedGroupId: null,
          selectedControllerIndex: null,
        ));
      }
    });

    on<UpdateLiveMessageEvent>(_onUpdateLiveMessage);
  }

  Future<void> _onUpdateLiveMessage(UpdateLiveMessageEvent event, Emitter<DashboardState> emit) async {
    if (state is! DashboardGroupsLoaded) return;

    final currentState = state as DashboardGroupsLoaded;
    final updatedGroupControllers = Map<int, List<ControllerEntity>>.from(currentState.groupControllers);
    bool updated = false;

    // Iterate over all groups' controllers to find the matching deviceId
    for (final entry in updatedGroupControllers.entries) {
      final groupId = entry.key;
      final controllers = entry.value;
      final updatedControllers = <ControllerEntity>[];
      bool groupUpdated = false;

      for (final ctrl in controllers) {
        if (ctrl.deviceId == event.deviceId) {
          // Cast to ControllerModel assuming it implements ControllerEntity and has copyWith
          final model = ctrl as ControllerModel;
          final updatedCtrl = model.copyWith(liveMessage: event.liveMessage);
          updatedControllers.add(updatedCtrl);
          groupUpdated = true;
          updated = true;
        } else {
          updatedControllers.add(ctrl);
        }
      }

      if (groupUpdated) {
        updatedGroupControllers[groupId] = updatedControllers;
      }
    }

    if (updated) {
      emit(currentState.copyWith(groupControllers: updatedGroupControllers));
    }
  }
}