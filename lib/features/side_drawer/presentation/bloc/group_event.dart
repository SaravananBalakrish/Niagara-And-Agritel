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