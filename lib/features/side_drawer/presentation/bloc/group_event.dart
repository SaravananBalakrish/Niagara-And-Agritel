import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGroupsEvent extends GroupEvent {
  final int userId;
  FetchGroupsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GroupAddEvent extends GroupEvent {
  final int userId;
  final String groupName;
  GroupAddEvent({required this.userId, required this.groupName});

  @override
  List<Object?> get props => [userId, groupName];
}