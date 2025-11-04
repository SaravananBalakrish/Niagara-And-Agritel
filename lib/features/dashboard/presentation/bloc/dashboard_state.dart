import 'package:equatable/equatable.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/domain/entities/group_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/domain/entities/controller_entity.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceIndex {
  final int groupId;
  final int controllerIndex;

  const DeviceIndex({
    required this.groupId,
    required this.controllerIndex,
  });
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardGroupsLoaded extends DashboardState {
  final List<GroupDetailsEntity> groups;
  final Map<int, List<ControllerEntity>> groupControllers;
  final int? selectedGroupId;
  final int? selectedControllerIndex;
  final Map<String, DeviceIndex> deviceIndexMap; // New: {deviceId: DeviceIndex}

  DashboardGroupsLoaded({
    required this.groups,
    required this.groupControllers,
    this.selectedGroupId,
    this.selectedControllerIndex,
    Map<String, DeviceIndex>? deviceIndexMap,
  }) : deviceIndexMap = deviceIndexMap ?? const {};

  DashboardGroupsLoaded copyWith({
    List<GroupDetailsEntity>? groups,
    Map<int, List<ControllerEntity>>? groupControllers,
    int? selectedGroupId,
    int? selectedControllerIndex,
    Map<String, DeviceIndex>? deviceIndexMap,
  }) {
    // Rebuild map if controllers change
    final updatedMap = Map<String, DeviceIndex>.from(this.deviceIndexMap);
    if (groupControllers != null) {
      updatedMap.clear();
      groupControllers.forEach((groupId, controllers) {
        for (int i = 0; i < controllers.length; i++) {
          final ctrl = controllers[i];
          if (ctrl is ControllerEntity) {
            updatedMap[ctrl.deviceId] = DeviceIndex(groupId: groupId, controllerIndex: i);
          }
        }
      });
    } else if (deviceIndexMap != null) {
      updatedMap.addAll(deviceIndexMap);
    }

    return DashboardGroupsLoaded(
      groups: groups ?? this.groups,
      groupControllers: groupControllers ?? this.groupControllers,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedControllerIndex: selectedControllerIndex ?? this.selectedControllerIndex,
      deviceIndexMap: updatedMap,
    );
  }

  @override
  List<Object?> get props => [
    groups,
    groupControllers,
    selectedGroupId,
    selectedControllerIndex,
    deviceIndexMap,
  ];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}