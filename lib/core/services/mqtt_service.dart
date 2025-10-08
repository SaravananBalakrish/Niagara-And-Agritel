import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart' if (dart.library.html) 'package:mqtt_client/mqtt_browser_client.dart';

class MqttService {
  final String broker;
  final int port;
  final String clientIdentifier;

  late MqttServerClient _client;
  bool _connected = false;

  MqttService({
    required this.broker,
    required this.port,
    required this.clientIdentifier,
  });

  Future<void> connect() async {
    _client = MqttServerClient(broker, clientIdentifier);
    _client.port = port;
    _client.logging(on: false);
    _client.keepAlivePeriod = 30;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } catch (e) {
      _client.disconnect();
      rethrow;
    }
  }

  void _onConnected() {
    _connected = true;
    print('MQTT connected');
  }

  void _onDisconnected() {
    _connected = false;
    print('MQTT disconnected');
  }

  bool get isConnected => _connected;

  void subscribe(String topic, {MqttQos qos = MqttQos.atMostOnce}) {
    if (_connected) {
      _client.subscribe(topic, qos);
    }
  }

  void publish(String topic, String message, {MqttQos qos = MqttQos.atMostOnce}) {
    if (_connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client.publishMessage(topic, qos, builder.payload!);
    }
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> get updates => _client.updates!;
}
