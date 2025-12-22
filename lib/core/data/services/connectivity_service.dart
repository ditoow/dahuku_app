import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check network connectivity status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device is currently connected to internet
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }

  /// Get current connectivity type
  Future<List<ConnectivityResult>> get connectivityType async {
    return await _connectivity.checkConnectivity();
  }
}
