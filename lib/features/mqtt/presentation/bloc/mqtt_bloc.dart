import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../../../../core/services/mqtt_service.dart';
import 'mqtt_event.dart';
import 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  final MqttService mqttService;
  StreamSubscription? _subscription;
  Timer? _retryTimer;
  int _retryAttempts = 0;
  static const int maxRetries = 5;
  static const Duration retryDelay = Duration(seconds: 5);

  MqttBloc({required this.mqttService}) : super(MqttInitial()) {
    on<ConnectMqttEvent>(_onConnect);
    on<SubscribeMqttEvent>(_onSubscribe);
    on<PublishMqttEvent>(_onPublish);
    on<ReceivedMqttMessageEvent>(_onReceivedMessage);
    add(ConnectMqttEvent());
  }

  Future<void> _onConnect(ConnectMqttEvent event, Emitter<MqttState> emit) async {
    emit(MqttLoading());
    try {
      await mqttService.connect();
      _retryAttempts = 0;
      emit(MqttConnected());

      // Listen to incoming messages
      _subscription = mqttService.updates.listen((messages) {
        for (var message in messages) {
          final payload = message.payload as MqttPublishMessage;
          final msgString = MqttPublishPayload.bytesToStringAsString(payload.payload.message);
          add(ReceivedMqttMessageEvent(topic: message.topic, message: msgString));
        }
      });
    } catch (e) {
      _retryAttempts++;
      final errorMsg = 'MQTT Connect failed (attempt $_retryAttempts/$maxRetries): $e';
      emit(MqttError(errorMsg));

      // Auto-retry on auth/network errors (not on max attempts)
      if (_retryAttempts < maxRetries && e.toString().contains('notAuthorized') || e.toString().contains('NoConnectionException')) {
        _retryTimer?.cancel();
        _retryTimer = Timer(retryDelay, () => add(ConnectMqttEvent()));
      } else if (_retryAttempts >= maxRetries) {
        print('🔵 MqttBloc._onConnect: Max retries exceeded; manual retry needed');
      }
    }
  }

  void _onSubscribe(SubscribeMqttEvent event, Emitter<MqttState> emit) {
    print("_onSubscribe called");
    if (state is MqttConnected) {
      mqttService.subscribe(event.topic);
    } else {
      print('🔵 MqttBloc._onSubscribe: Skipped; not connected');
    }
  }

  void _onPublish(PublishMqttEvent event, Emitter<MqttState> emit) {
    if (state is MqttConnected) {
      mqttService.publish(event.topic, event.message);
    } else {
      print('🔵 MqttBloc._onPublish: Skipped; not connected');
    }
  }

  void _onReceivedMessage(ReceivedMqttMessageEvent event, Emitter<MqttState> emit) {
    print("Subscribed topic :: ${event.topic}");
    print("Received message :: ${event.message}");
    emit(MqttMessageReceived(topic: event.topic, message: event.message));
  }

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    _subscription?.cancel();
    return super.close();
  }
}