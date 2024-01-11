import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Serverdb {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<bool> getTime() async {
    log("server_start");
    bool server_status = false;
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('server')
          .doc('ejkgqPsuQFhGzXVmDEJr')
          .get();

      Map<String, dynamic>? data =
      documentSnapshot.data() as Map<String, dynamic>?;
      log("server_Status$data");

      if (data != null) {
        server_status = data['server_status'] == true;
        log("server_status: $server_status");
      }
      return server_status;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
