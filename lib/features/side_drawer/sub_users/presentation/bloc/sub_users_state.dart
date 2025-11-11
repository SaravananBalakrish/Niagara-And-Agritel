import 'package:equatable/equatable.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/entities/sub_user_entity.dart';

import '../../domain/entities/sub_user_details_entity.dart';

abstract class SubUsersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubUserLoading extends SubUsersState {}
class SubUserInitial extends SubUsersState {}

class SubUsersLoaded extends SubUsersState {
  final List<SubUserEntity> subUsersList;
  SubUsersLoaded({required this.subUsersList});

  @override
  List<Object?> get props => [subUsersList];
}

class SubUsersError extends SubUsersState {
  final String message;
  SubUsersError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SubUserDetailsLoading extends SubUsersState {}

class SubUserDetailsLoaded extends SubUsersState {
  final SubUserDetailsEntity subUserDetails;
  SubUserDetailsLoaded({required this.subUserDetails});

  @override
  List<Object?> get props => [subUserDetails];
}

class SubUserDetailsError extends SubUsersState {
  final String message;
  SubUserDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}