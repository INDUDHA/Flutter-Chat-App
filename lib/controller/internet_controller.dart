import 'dart:developer';
import 'dart:ui';
import 'package:chatapp/views/no_internet.dart';
import 'package:chatapp/views/welcome.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/chat.dart';

class InternetController extends GetxController {
  int connectionType = 0;
  late bool result;

  @override
  void onInit() {
    super.onInit();
    getConnectionType();
  }

  @override
  void dispose() {
    super.dispose();
  }

  navigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('user_email');
    bool? login_Value = prefs.getBool('login_in');
    String? selected_language = prefs.getString('selected_language');
    log(stringValue.toString());
    log("login_value" + login_Value.toString());
    Locale selectedValue =
        selected_language != null ? Locale(selected_language) : Locale("en");
    if (login_Value == true) {
      Get.to(() => Chat());
      await Get.updateLocale(selectedValue);
    } else {
      Get.to(() => Welcome());
    }
  }

  Future<void> getConnectionType() async {
    var connectivityResult;
    try {
      connectivityResult = await InternetConnection();
      result = await InternetConnection().hasInternetAccess;
      log("connectivityResult $connectivityResult");
      log("result $result".toString());

      final listener = InternetConnection().onStatusChange.listen(
        (InternetStatus status) {
          switch (status) {
            case InternetStatus.connected:
              connectionType = 1;
              navigation();
              log("Internet connected");
              break;
            case InternetStatus.disconnected:
              connectionType = 0;
              Get.to(() => no_internet());
              log("no_internet");
              break;
            default:
              Get.snackbar(
                'Network Error',
                'Failed to get Network Status',
              );
              log("Network error");
              break;
          }
        },
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
