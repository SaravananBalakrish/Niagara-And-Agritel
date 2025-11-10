import 'package:bloc/bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/get_sub_user_details_usecase.dart';
import '../../domain/usecases/get_sub_users_usecase.dart';
import 'sub_users_event.dart';
import 'sub_users_state.dart';

class SubUsersBloc extends Bloc<SubUsersEvent, SubUsersState> {
  final GetSubUsersUsecase getSubUsersUsecase;
  final GetSubUserDetailsUsecase getSubUserDetailsUsecase;
  SubUsersBloc({
    required this.getSubUsersUsecase,
    required this.getSubUserDetailsUsecase,
  }) : super(SubUserInitial()) {
    on<GetSubUsersEvent>(_onGetSubUsers);
    on<LoadSubUserDetailsEvent>(_onGetSubUserDetails);
  }

  Future<void> _onGetSubUsers(GetSubUsersEvent event, Emitter<SubUsersState> emit) async {
    print('Event received for userId: ${event.userId}');
    emit(SubUserLoading());
    final result = await getSubUsersUsecase(GetSubUsersParams(userId: event.userId));
    result.fold(
          (failure) => emit(SubUsersError(message: failure.message)),
          (subUsers) {
        emit(SubUsersLoaded(subUsersList: subUsers));
      },
    );
  }

  Future<void> _onGetSubUserDetails(LoadSubUserDetailsEvent event, Emitter<SubUsersState> emit) async {
    emit(SubUserLoading());
    final result = await getSubUserDetailsUsecase(
        GetSubUserDetailsParams(
            userId: event.subUserDetailsParams.userId,
            subUserCode: event.subUserDetailsParams.subUserCode
        )
    );
    result.fold(
          (failure) => emit(SubUserDetailsError(message: failure.message)),
          (subUserDetails) {
        emit(SubUserDetailsLoaded(subUserDetails: subUserDetails));
      },
    );
  }
}