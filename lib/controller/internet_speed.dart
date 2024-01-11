import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_test_dart/classes/server.dart';
import 'package:speed_test_dart/speed_test_dart.dart';

class Internetspeed extends GetxController {
  List<Server> bestServersList = [];
  late double download_speed;

  Future<double> setBestServers() async {
    SpeedTestDart tester = SpeedTestDart();
    final settings = await tester.getSettings();
    final servers = settings.servers;
    final _bestServersList = await tester.getBestServers(
      servers: servers,
    );
    log(_bestServersList.toString());
    update();
    bestServersList = _bestServersList;
    final downloadRate =
        await tester.testDownloadSpeed(servers: bestServersList);
    log("download $downloadRate");
    final uploadRate = await tester.testUploadSpeed(servers: bestServersList);
    log("upload $uploadRate");
    update();
    download_speed = downloadRate;

    Get.snackbar(
      "Internet Speed",
      "Download Speed: $download_speed Mbps",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
      barBlur: 20,
    );
    return download_speed;
  }
}
