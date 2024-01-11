import 'dart:developer';

import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFirestoreDb {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<void> addUser(UserModel usermodel) async {
    FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('users').add({
      'Name': usermodel.Emailid,
      'Email_id': usermodel.Emailid,
      "fcm_token": usermodel.fcm_token
    });
    await docRef.update({'user_id': docRef.id});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', docRef.id);


  }

  static Future<void> addUserGoogle(UserModel googlemodel) async {
    FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;

    QuerySnapshot existingUsers = await FirebaseFirestore.instance
        .collection('users')
        .where('Email_id', isEqualTo: googlemodel.Emailid)
        .get();

    if (existingUsers.docs.isNotEmpty) {
      print('User with this email already exists.');
      return;
    }

    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('users').add({
      'Name': googlemodel.Name,
      'Email_id': googlemodel.Emailid,
      'Profile_Url': googlemodel.UserImage,
      "fcm_token": googlemodel.fcm_token
    });

    await docRef.update({'user_id': docRef.id});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', docRef.id);

  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    List<Map<String, dynamic>> userList = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      querySnapshot.docs.forEach((doc) {
        userList.add(doc.data() as Map<String, dynamic>);
      });
      return userList;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
