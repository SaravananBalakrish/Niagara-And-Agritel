import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/usecsases/get_menu_items.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/bloc/pump_settings_event.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/presentation/bloc/pump_settings_state.dart';

class PumpSettingsBloc extends Bloc<PumpSettingsEvent, PumpSettingsState> {
  final GetPumpSettingsUsecase getPumpSettingsUsecase;

  PumpSettingsBloc({
    required this.getPumpSettingsUsecase
  }) : super(GetPumpSettingsInitial()) {
    on<GetPumpSettingsEvent>((event, emit) async{
      emit(GetPumpSettingsInitial());

      final result = await getPumpSettingsUsecase(
          GetPumpSettingsParams(
              userId: event.userId,
              subUserId: event.subUserId,
              controllerId: event.controllerId,
              menuId: event.menuId
          )
      );

      result.fold(
              (failure) => emit(GetPumpSettingsError(message: failure.message)),
              (settings) => emit(GetPumpSettingsLoaded(settings: settings))
      );
    });
  }
}