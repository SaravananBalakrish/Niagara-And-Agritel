abstract class MqttState {}
class MqttInitial extends MqttState {}
class MqttLoading extends MqttState {}
class MqttConnected extends MqttState {}
class MqttError extends MqttState {
  final String message;
  MqttError(this.message);
}

// New state: contains received message
class MqttMessageReceived extends MqttState {
  final String topic;
  final String message;
  MqttMessageReceived({required this.topic, required this.message});
}
