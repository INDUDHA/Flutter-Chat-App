import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? MessageId;
  String? Userid;
  String? Message_from;
  String? Message_to;
  String? Time;
  String? Username;
  String? Text;
  MessageModel(
      { this.Userid, this.Message_from, this.Message_to, this.Time,this.Username,this.Text});

  MessageModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    Userid = documentSnapshot.id;
    Message_from = documentSnapshot["Message_from"];
    Message_to = documentSnapshot["Message_to"];
    Time = documentSnapshot['Time'];
    Username = documentSnapshot['User_name'];
    Text = documentSnapshot['Text'];
  }
}
