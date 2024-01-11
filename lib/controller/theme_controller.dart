import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

  ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
  );

  ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
  );
}
