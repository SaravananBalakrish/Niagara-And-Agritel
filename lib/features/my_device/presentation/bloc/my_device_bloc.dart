import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_device_event.dart';
import 'my_device_state.dart';
import '../../domain/entities/controller_entity.dart';

class MyDeviceBloc extends Bloc<MyDeviceEvent, MyDeviceState> {
  MyDeviceBloc() : super(MyDeviceInitial()) {
    on<LoadControllers>(_onLoadControllers);
  }

  void _onLoadControllers(LoadControllers event, Emitter<MyDeviceState> emit) async {
    emit(MyDeviceLoading());

    await Future.delayed(const Duration(seconds: 1)); // mock delay

    // mock data
    final controllers = [
      ControllerEntity(
        id: "1",
        name: "Niagara Testing Unit",
        mqttConnected: true,
        liveSync: "01/08/2024 13:14:16",
        smsSync: "01/08/2024 13:14:09",
        signal: 58,
        battery: 96,
        status: "MOB MOTOR OFF II",
        vrb: 248,
        amp: 0.0,
        r: 124,
        y: 125,
        b: 248,
        c1: 0.0,
        c2: 0.0,
        c3: 0.0,
        motorOn: false,
        valveOn: false,
        prsIn: 0.0,
        prsOut: 0.0,
        activeZone: "No Active Zone",
        setTime: "NA",
        remainingTime: "NA",
        tabIndex: 0,
      ),
    ];

    emit(MyDeviceLoaded(controllers));
  }
}
