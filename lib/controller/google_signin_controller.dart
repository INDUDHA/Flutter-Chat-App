import 'dart:developer';

import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/views/chat.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firestore_user_controller.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;



class GController extends GetxController {
  Future<void> login(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      String userName = result.user!.displayName.toString();
      String userEmail = result.user!.email.toString();
      String photo = result.user!.photoURL.toString();
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcm = await messaging.getToken();

      final googlemodel = UserModel(
          Emailid: userEmail,
          Name: userName,
          UserImage: photo,
          fcm_token: fcm.toString());
      UserFirestoreDb.addUserGoogle(googlemodel);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_email', userName);
      prefs.setBool('login_in', true);
      prefs.setString('user_name', userName);
      Get.to(() => const Chat(), arguments: {'name': userName});
    }
  }
}
