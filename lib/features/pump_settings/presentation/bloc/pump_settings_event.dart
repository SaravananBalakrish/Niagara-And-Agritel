import 'package:equatable/equatable.dart';

class PumpSettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPumpSettingsMenuEvent extends PumpSettingsEvent {
  final int userId, controllerId, subUserId;
  GetPumpSettingsMenuEvent({required this.userId, required this.subUserId, required this.controllerId});

  @override
  List<Object?> get props => [];
}