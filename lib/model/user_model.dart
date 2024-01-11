import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? UserId;
  late String Emailid;
  String? Name;
  String? UserImage;
  late String fcm_token;
  UserModel({required this.Emailid, this.Name, this.UserImage,required this.fcm_token});

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    UserId = documentSnapshot.id;
    Emailid = documentSnapshot["email_id"];
    Name = documentSnapshot["name"];
    UserImage = documentSnapshot["user_image"];
    fcm_token = documentSnapshot["fcm_token"];
  }
}
