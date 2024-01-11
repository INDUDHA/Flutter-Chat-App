import 'dart:developer';
import 'package:chatapp/views/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import 'firestore_user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userEmail = userCredential.user!.email.toString();
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcm = await messaging.getToken();
      final userModel =
          UserModel(Emailid: userEmail, fcm_token: fcm.toString());
      UserFirestoreDb.addUser(userModel);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_email', userEmail);
      prefs.setBool('login_in', true);
      Get.to(() => const Chat(), arguments: {'name': userEmail});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Get.snackbar('Error', 'The password provided is too weak.',
        //     backgroundColor: (Colors.white));
        Get.showSnackbar(GetSnackBar(
            title: 'ERROR',
            message: 'The password provided is too weak.',
            icon: Icon(Icons.refresh_sharp),
            duration: const Duration(seconds: 3)));
      } else if (e.code == 'email-already-in-use') {
        // Get.snackbar('Error', 'The account already exists for that email.',
        //     backgroundColor: (Colors.white));
        Get.showSnackbar(GetSnackBar(
            title: 'ERROR',
            message: 'The account already exists for that email.',
            icon: Icon(Icons.refresh_sharp),
            duration: const Duration(seconds: 3)));
      } else {
        // Get.snackbar(
        //     'Error', e.message ?? 'An error occurred while signing up.',
        //     backgroundColor: (Colors.white));
        Get.showSnackbar(GetSnackBar(
            title: 'ERROR',
            message: 'An error occurred while signing up.',
            icon: Icon(Icons.refresh_sharp),
            duration: const Duration(seconds: 3)));
      }
    } catch (e) {
      log((e).toString());
      // Get.snackbar('Error', 'An error occurred while signing up.',
      //     backgroundColor: (Colors.white));
      Get.showSnackbar(GetSnackBar(
          title: 'ERROR',
          message: 'An error occurred while signing up.',
          icon: Icon(Icons.refresh_sharp),
          duration: const Duration(seconds: 3)));
    }
  }
}
