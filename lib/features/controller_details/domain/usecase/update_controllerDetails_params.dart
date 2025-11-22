import 'package:equatable/equatable.dart';

class UpdateControllerDetailsParams extends Equatable {
  final int userId;
  final int controllerId;
  final String countryCode;
  final String simNumber;
  final String deviceName;
  final int groupId;
  final String operationMode;
  final String gprsMode;
  final String appSmsMode;

  const UpdateControllerDetailsParams({
    required this.userId,
    required this.controllerId,
    required this.countryCode,
    required this.simNumber,
    required this.deviceName,
    required this.groupId,
    required this.operationMode,
    required this.gprsMode,
    required this.appSmsMode,
  });

  @override
  List<Object?> get props => [
    userId,
    controllerId,
    countryCode,
    simNumber,
    deviceName,
    groupId,
    operationMode,
    gprsMode,
    appSmsMode,
  ];
}