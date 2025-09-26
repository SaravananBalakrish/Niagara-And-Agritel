import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../../../../core/services/mqtt_service.dart';
import 'mqtt_event.dart';
import 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  final MqttService mqttService;
  StreamSubscription? _subscription;

  MqttBloc({required this.mqttService}) : super(MqttInitial()) {
    on<ConnectMqttEvent>(_onConnect);
    on<SubscribeMqttEvent>(_onSubscribe);
    on<PublishMqttEvent>(_onPublish);
    on<ReceivedMqttMessageEvent>(_onReceivedMessage);
  }

  Future<void> _onConnect(ConnectMqttEvent event, Emitter<MqttState> emit) async {
    emit(MqttLoading());
    try {
      await mqttService.connect();
      emit(MqttConnected());

      // Listen to incoming messages
      _subscription = mqttService.updates.listen((messages) {
        for (var message in messages) {
          final payload = message.payload as MqttPublishMessage;
          final msgString =
          MqttPublishPayload.bytesToStringAsString(payload.payload.message);
          add(ReceivedMqttMessageEvent(topic: message.topic, message: msgString));
        }
      });
    } catch (e) {
      emit(MqttError(e.toString()));
    }
  }

  void _onSubscribe(SubscribeMqttEvent event, Emitter<MqttState> emit) {
    mqttService.subscribe(event.topic);
  }

  void _onPublish(PublishMqttEvent event, Emitter<MqttState> emit) {
    mqttService.publish(event.topic, event.message);
  }

  void _onReceivedMessage(ReceivedMqttMessageEvent event, Emitter<MqttState> emit) {
    emit(MqttMessageReceived(topic: event.topic, message: event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
