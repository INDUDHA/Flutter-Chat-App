import 'dart:developer';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/server_down.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/firebase_server_controller.dart';
import '../controller/theme_controller.dart';

class language_change extends StatefulWidget {
  const language_change({super.key});

  @override
  State<language_change> createState() => _language_changeState();
}

class _language_changeState extends State<language_change> {
  late FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;
  late bool server_status = false;
  late ThemeController themeController;

  get_server() async {
    dynamic resultant = await Serverdb.getTime();
    server_status = resultant;
    log("server_check$resultant");
    if (server_status == true) {
      Get.to(() => serverDown());
    }
  }

  Locale selectedValue = const Locale('en', 'US');

  List<Map<String, dynamic>> supportedLanguages = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Kannada', 'locale': const Locale('kn', 'IN')},
    {'name': 'Hindi', 'locale': const Locale('hi', 'IN')},
    {'name': 'Telugu', 'locale': const Locale('te', 'IN')},
    {'name': 'Tamil', 'locale': const Locale('ta', 'IN')},
  ];

  change_language_submit_button_event() async {
    log("event_start");
    await mFirebaseAnalytics.logEvent(name: "change_language_selection");
    log("event_end");
  }

  Widget _buildLanguageButton(String name, Locale locale) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedValue = locale;
          });
        },
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          backgroundColor: selectedValue == locale ? Colors.blue : Colors.white,
          fixedSize: const Size(350, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: selectedValue == locale ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    get_server();
    themeController = Get.put(ThemeController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please select your Language",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: supportedLanguages
                  .map((language) => _buildLanguageButton(
                      language['name'], language['locale']))
                  .toList(),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                log("change_language");
                await Get.updateLocale(selectedValue);
                Get.to(() => Chat());
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
                backgroundColor: Colors.blue,
                fixedSize: const Size(350, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
