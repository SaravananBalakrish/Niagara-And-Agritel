import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Optional: Stream to listen for changes in connectivity
  Stream<bool> get onConnectivityChanged =>
      connectivity.onConnectivityChanged.map((event) => event != ConnectivityResult.none);
}
