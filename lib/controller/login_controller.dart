import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/views/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  FirebaseAuth _auth = FirebaseAuth.instance;
  onInit(){
    super.onInit();
  }


  addStringToSF(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
    prefs.setBool('login_in', true);
    log("signIN : ${prefs.getBool('login_in')}");
    email = '';
    password = '';
  }

  Future<void> signIn(String email, String password) async {
    FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log(email);
      Get.to(() => const Chat());
      addStringToSF(email, password);

    } 
    on FirebaseAuthException catch (e) {
      log((e.message).toString());
      Get.showSnackbar(GetSnackBar(
          title: 'ERROR',
          message: e.code,
          icon: Icon(
            Icons.refresh_sharp,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3)));
    }
  }
}
