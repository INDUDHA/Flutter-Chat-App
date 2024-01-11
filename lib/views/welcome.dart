import 'dart:developer';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/language_selection.dart';
import 'package:chatapp/views/no_internet.dart';
import 'package:chatapp/views/server_down.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/firebase_server_controller.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late FirebaseAnalytics mFirebaseAnalytics;
  late bool server_status = false;

  get_server() async {
    dynamic resultant = await Serverdb.getTime();
    server_status = resultant;
    log("server_check$resultant");
    if (server_status == true) {
      Get.to(() => serverDown());
    }
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
      Get.to(() => language_view());
    }
  }

  get_started_button_event() async {
    log("event_start");
    await mFirebaseAnalytics
        .logEvent(name: "get_started", parameters: {"id": "1"});
    // FirebaseCrashlytics.instance.crash();
    log("event_end");
  }

  @override
  void initState() {
    super.initState();
    get_server();
    mFirebaseAnalytics = FirebaseAnalytics.instance;
    mFirebaseAnalytics.setAnalyticsCollectionEnabled(true);
    mFirebaseAnalytics.getSessionId().then((value) => log("sessionId :$value"));
    mFirebaseAnalytics.setCurrentScreen(screenName: "splash_screen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: Colors.black,
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Image.asset(
                'assets/images/welcome.png',
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'title'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'sub_title_1'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () async {
                      await get_started_button_event();
                      // Get.to(const Login());
                      navigation();
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      backgroundColor: Colors.white,
                      fixedSize: const Size(350, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Text(
                      'sub_title_2'.tr,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
