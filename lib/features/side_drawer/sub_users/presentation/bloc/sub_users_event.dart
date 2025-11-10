import 'package:equatable/equatable.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/get_sub_user_details_usecase.dart';

abstract class SubUsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetSubUsersEvent extends SubUsersEvent {
  final int userId;
  GetSubUsersEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadSubUserDetailsEvent extends SubUsersEvent {
  final GetSubUserDetailsParams subUserDetailsParams;
  LoadSubUserDetailsEvent({required this.subUserDetailsParams});

  @override
  List<Object?> get props => [subUserDetailsParams];
}