import '../../domain/entities/controller_entity.dart';

abstract class MyDeviceState {}

class MyDeviceInitial extends MyDeviceState {}

class MyDeviceLoading extends MyDeviceState {}

class MyDeviceLoaded extends MyDeviceState {
  final List<ControllerEntity> controllers;
  MyDeviceLoaded(this.controllers);
}

class MyDeviceError extends MyDeviceState {
  final String message;
  MyDeviceError(this.message);
}
