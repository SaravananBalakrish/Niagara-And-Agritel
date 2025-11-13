import 'package:bloc/bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/get_sub_user_details_usecase.dart';
import '../../domain/entities/sub_user_details_entity.dart';
import '../../domain/usecases/get_sub_users_usecase.dart';
import '../../domain/usecases/update_sub_user_usecase.dart';
import 'sub_users_event.dart';
import 'sub_users_state.dart';

class SubUsersBloc extends Bloc<SubUsersEvent, SubUsersState> {
  final GetSubUsersUsecase getSubUsersUsecase;
  final GetSubUserDetailsUsecase getSubUserDetailsUsecase;
  final UpdateSubUserDetailsUseCase updateSubUserDetailsUseCase;
  SubUsersBloc({
    required this.getSubUsersUsecase,
    required this.getSubUserDetailsUsecase,
    required this.updateSubUserDetailsUseCase,
  }) : super(SubUserInitial()) {
    on<GetSubUsersEvent>(_onGetSubUsers);
    on<GetSubUserDetailsEvent>(_onGetSubUserDetails);
    on<UpdateControllerSelectionEvent>(_onUpdateSelection);
    on<UpdateControllerDndEvent>(_onUpdateDnd);
    on<SubUserDetailsUpdateEvent>(_onUpdateDetails);
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

  Future<void> _onGetSubUserDetails(GetSubUserDetailsEvent event, Emitter<SubUsersState> emit) async {
    emit(SubUserDetailsLoading());
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

  Future<void> _onUpdateSelection(
      UpdateControllerSelectionEvent event,
      Emitter<SubUsersState> emit,
      ) async {
    if (state is SubUserDetailsLoaded) {
      final currentState = state as SubUserDetailsLoaded;
      // Create immutable copy and update
      final updatedList = List<SubUserControllerEntity>.from(currentState.subUserDetails.controllerList);
      final controller = updatedList[event.controllerIndex];
      updatedList[event.controllerIndex] = SubUserControllerEntity(
        userDeviceId: controller.userDeviceId,
        productId: controller.productId,
        deviceName: controller.deviceName,
        deviceId: controller.deviceId,
        simNumber: controller.simNumber,
        dndStatus: controller.dndStatus,
        shareFlag: event.isSelected ? 1 : 0,
      );
      final updatedDetails = SubUserDetailsEntity(
        subUserDetail: currentState.subUserDetails.subUserDetail,
        controllerList: updatedList,
      );
      emit(SubUserDetailsLoaded(subUserDetails: updatedDetails));
    }
  }

  Future<void> _onUpdateDnd(
      UpdateControllerDndEvent event,
      Emitter<SubUsersState> emit,
      ) async {
    if (state is SubUserDetailsLoaded) {
      final currentState = state as SubUserDetailsLoaded;
      final updatedList = List<SubUserControllerEntity>.from(currentState.subUserDetails.controllerList);
      final controller = updatedList[event.controllerIndex];
      updatedList[event.controllerIndex] = SubUserControllerEntity(
        userDeviceId: controller.userDeviceId,
        productId: controller.productId,
        deviceName: controller.deviceName,
        deviceId: controller.deviceId,
        simNumber: controller.simNumber,
        dndStatus: event.isEnabled ? '1' : '0',
        shareFlag: controller.shareFlag,
      );
      final updatedDetails = SubUserDetailsEntity(
        subUserDetail: currentState.subUserDetails.subUserDetail,
        controllerList: updatedList,
      );
      emit(SubUserDetailsLoaded(subUserDetails: updatedDetails));
    }
  }

  Future<void> _onUpdateDetails(
      SubUserDetailsUpdateEvent event,
      Emitter<SubUsersState> emit,
      ) async {
    emit(SubUserDetailsUpdateStarted());
    final result = await updateSubUserDetailsUseCase(event.updatedDetails);
    result.fold(
          (failure) => emit(SubUserDetailsUpdateError(message: failure.message)),
          (message) => emit(SubUserDetailsUpdateSuccess(message: message)),
    );
  }
}