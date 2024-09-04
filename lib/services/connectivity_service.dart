import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>.broadcast();

  ConnectivityService() {
    // Listen to connectivity changes and add them to the stream
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityStreamController.add(result);
    });
  }

  // Function to get the current connectivity status
  Future<ConnectivityResult> getCurrentConnectivity() async {
    return await Connectivity().checkConnectivity();
  }

  // Stream to listen for connectivity changes
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityStreamController.stream;

  // Dispose the stream controller when it's no longer needed
  void dispose() {
    _connectivityStreamController.close();
  }
}
