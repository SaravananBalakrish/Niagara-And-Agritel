import 'package:equatable/equatable.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/settings_menu_entity.dart';

class PumpSettingsState extends Equatable {
  @override List<Object?> get props => [];
}

class GetPumpSettingsMenuInitial extends PumpSettingsState {}

class GetPumpSettingsMenuLoaded extends PumpSettingsState {
  final List<SettingsMenuEntity> settingMenuList;
  GetPumpSettingsMenuLoaded({required this.settingMenuList});

  @override List<Object?> get props => [settingMenuList];
}

class GetPumpSettingsMenuError extends PumpSettingsState {
  final String message;
  GetPumpSettingsMenuError({required this.message});

  @override List<Object?> get props => [message];
}