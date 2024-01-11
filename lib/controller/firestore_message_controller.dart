import 'dart:convert';
import 'dart:developer';

import 'package:chatapp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageFirestoreDb {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // List<Map<String, dynamic>> messageList = [];

  static Future<void> addUser(MessageModel messageModel) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('message').add({
      'Userid': messageModel.Userid,
      'User_name': messageModel.Username,
      'Message_to': messageModel.Message_to,
      "Message_from": messageModel.Message_from,
      "Time": messageModel.Time,
      "Text": messageModel.Text
    });
    await docRef.update({'MessageId': docRef.id});
  }

  static Future<List<Map<String, dynamic>>> getUsers(
      {String? from, dynamic from_user, String? to, dynamic to_user}) async {
    List<Map<String, dynamic>> messageList = [];

    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('message');

      QuerySnapshot querySnapshot;

      if (from != null && from_user != null && to != null && to_user != null) {
        querySnapshot = await collection
            .where(from, isEqualTo: from_user)
            .where(to, isEqualTo: to_user)
            // .orderBy('Time', descending: true)
            .get();
        log(from + "" + from_user);
        log(to + "" + to_user);
      } else {
        querySnapshot = await collection.get();
        log("else");
      }
      querySnapshot.docs.forEach((doc) {
        messageList.add(doc.data() as Map<String, dynamic>);
        log("added to array");
      });
      messageList.sort((a, b) => a["Time"].compareTo(b["Time"]));
      log('sortm'+messageList.toString());
      return messageList;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getUsers1(
      {String? from, dynamic from_user, String? to, dynamic to_user}) async {
    List<Map<String, dynamic>> messageList1 = [];

    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('message');

      QuerySnapshot querySnapshot;

      if (from != null && from_user != null && to != null && to_user != null) {
        querySnapshot = await collection
            .where(to, isEqualTo: from_user)
            .where(from, isEqualTo: to_user)
            // .orderBy('Time', descending: true)
            .get();
        log(from + "" + from_user);
        log(to + "" + to_user);
      } else {
        querySnapshot = await collection.get();
        log("else");
      }
      querySnapshot.docs.forEach((doc) {
        messageList1.add(doc.data() as Map<String, dynamic>);
        log("added to array");
      });
      messageList1.sort(((a, b) => a["Time"].compareTo(b["Time"])));
      log("sortm1"+messageList1.toString());
      return messageList1;
    } catch (e) {
      return [];
    }
  }

  static Future<String> getTime() async {
    String time = "";
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('time_interval')
          .doc('np0FulX0wk1YQrnPasyG')
          .get();

      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        time = json.encode(data);
        time = const JsonEncoder.withIndent('  ').convert(data);
      }
      return time;
    } catch (e) {
      log(e.toString());
      return "";
    }
  }
}
