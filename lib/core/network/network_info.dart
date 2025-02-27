import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mohamed_application/main.dart';

// For checking Internet connectivity
abstract class NetworkInfo {
  Future<bool> isConnected();
  Future<List<ConnectivityResult>> get connectivityResult;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  static final NetworkInfoImpl _networkInfo = NetworkInfoImpl._internal(Connectivity());

  factory NetworkInfoImpl() {
    return _networkInfo;
  }

  NetworkInfoImpl._internal(this.connectivity);

  /// Checks if the internet is connected or not
  /// Returns `true` if the internet is connected, otherwise returns `false`
  @override
  Future<bool> isConnected() async {
    final result = await connectivityResult;
    return result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi);
  }

  /// To check the type of internet connectivity
  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return connectivity.checkConnectivity();
  }

  /// Checks the type of internet connection on change of internet connection
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => connectivity.onConnectivityChanged;
}

// General failure classes
abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

// Exception classes
class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

/// Can be used for throwing NoInternetException
class NoInternetException implements Exception {
  late String message;

  NoInternetException([this.message = "NoInternetException Occurred"]) {
    if (globalMessengerKey.currentState != null) {
      globalMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  String toString() {
    return message;
  }
}
