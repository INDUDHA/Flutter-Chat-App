import 'dart:developer';
import 'package:chatapp/controller/internet_controller.dart';
import 'package:chatapp/controller/language_controller.dart';
import 'package:chatapp/controller/network_controller.dart';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/language_selection.dart';
import 'package:chatapp/views/login.dart';
import 'package:chatapp/views/no_internet.dart';
import 'package:chatapp/views/server_down.dart';
import 'package:chatapp/views/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmToken = await messaging.getToken();
  log(fcmToken.toString());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final networkController = NetworkController();

  final internetController = InternetController();
  final ThemeController themeController = Get.put(ThemeController());

  void initState() {
    super.initState();
    // networkController.onInit();
    internetController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: themeController.theme,
        darkTheme: themeController.darkTheme,
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        translations: language_translation(),
        locale: Get.deviceLocale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: Welcome());
    // home: serverDown());
    // home: no_internet());
  }
}
