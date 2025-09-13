abstract class MqttEvent {}

class ConnectMqttEvent extends MqttEvent {}
class SubscribeMqttEvent extends MqttEvent {
  final String topic;
  SubscribeMqttEvent(this.topic);
}
class PublishMqttEvent extends MqttEvent {
  final String topic;
  final String message;
  PublishMqttEvent({required this.topic, required this.message});
}

// New event: triggered when a message is received
class ReceivedMqttMessageEvent extends MqttEvent {
  final String topic;
  final String message;
  ReceivedMqttMessageEvent({required this.topic, required this.message});
}
