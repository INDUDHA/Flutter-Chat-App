import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chatapp/views/no_internet.dart';
import 'package:chatapp/views/welcome.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  int connectionType = 0;
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  int network_speed = 0;

  @override
  void onInit() {
    super.onInit();
    getConnectionType();
    _connectivity.onConnectivityChanged.listen(_updateState);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getConnectionType() async {
    var connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
      log("connect_Result" + connectivityResult.toString());
    } on PlatformException catch (e) {
      print(e);
    }
    return _updateState(connectivityResult);
  }

  _updateState(ConnectivityResult result) {
    updateConnectionStatus();
    switch (result) {
      case ConnectivityResult.mobile:
        log("connected to mobile network");
        Get.to(() => Welcome());
        connectionType = 1;
        break;
      case ConnectivityResult.wifi:
        Get.to(() => Welcome());
        log("connected to wifi network");
        connectionType = 1;
        break;

      case ConnectivityResult.none:
        connectionType = 0;
        break;
      default:
        Get.snackbar('Network Error', 'Failed to get Network Status');
        log("network_error");
        break;
    }

    if (connectionType == 0) {
      Get.to(() => no_internet());
      log("no internet");
    } else {
      updateConnectionStatus().then((bool isConnected) {
        if (isConnected) {
          Get.back();
        }
      });
    }
  }

  Future<bool> updateConnectionStatus() async {
    try {
      final isConnected = await InternetConnection().hasInternetAccess;
      return isConnected;
    } on SocketException catch (e) {
      print("NETWORK_EXCEPTION " + e.toString());
      return false;
    }
  }
}
