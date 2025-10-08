import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_dealer_stats.dart';
import 'dealer_event.dart';
import 'dealer_state.dart';

class DealerBloc extends Bloc<DealerEvent, DealerState> {
  final GetDealerStats getDealerStats;

  DealerBloc(this.getDealerStats) : super(DealerInitial()) {
    on<LoadDealerStats>((event, emit) async {
      emit(DealerLoading());
      try {
        final dealer = await getDealerStats(event.dealerId);
        emit(DealerLoaded(dealer));
      } catch (e) {
        emit(DealerError(e.toString()));
      }
    });
  }
}
