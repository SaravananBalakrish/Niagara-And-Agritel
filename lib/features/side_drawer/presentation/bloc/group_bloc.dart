import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/usecases/group_fetching_usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/bloc/group_event.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/presentation/bloc/group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupFetchingUsecase groupFetchingUsecase;

  GroupBloc({
    required this.groupFetchingUsecase
  }) : super(GroupInitial()) {
    on<FetchGroupsEvent>((event, emit) async {
      emit(GroupLoading());
      final result = await groupFetchingUsecase(GroupFetchParams(event.userId));

      result.fold(
            (failure) => emit(GroupFetchingError(message: failure.message)),
            (groups) {
          emit(GroupLoaded(groups: groups));
        },
      );
    });
  }
}