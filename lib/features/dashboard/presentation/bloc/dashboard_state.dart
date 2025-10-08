import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardGroupsLoaded extends DashboardState {
  final dynamic groups;
  DashboardGroupsLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}