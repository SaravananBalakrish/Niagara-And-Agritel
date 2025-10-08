import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDashboardGroupsEvent extends DashboardEvent {
  final int userId;
  FetchDashboardGroupsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}