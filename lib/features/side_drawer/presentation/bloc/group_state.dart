import 'package:equatable/equatable.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/entities/group_entity.dart';

abstract class GroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}
class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupEntity> groups;

  GroupLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class GroupFetchingError extends GroupState {
  final String message;
  GroupFetchingError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GroupAddingStarted extends GroupState {}

class GroupAddingLoaded extends GroupState {
  final String message;

  GroupAddingLoaded({required this.message});
  @override
  List<Object?> get props => [message];
}

class GroupAddingError extends GroupState {
  final String message;

  GroupAddingError({required this.message});
  @override
  List<Object?> get props => [message];
}