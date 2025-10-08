import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawer_event.dart';
import 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc({required String userName, required String userRole})
      : super(DrawerState.initial(userName: userName, userRole: userRole)) {
    on<ToggleDrawerItemVisibility>((event, emit) {
      final updatedItems = state.items.map((item) {
        if (item.id == event.itemId) {
          return item.copyWith(isVisible: !item.isVisible);
        }
        return item;
      }).toList();
      emit(state.copyWith(items: updatedItems));
    });
  }
}
