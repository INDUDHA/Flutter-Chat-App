import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_screen.dart';

class CustomList extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  CustomList({required this.name, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/images/status_image.png'),
      title: Text((name),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      onTap: () {
        Get.to(const chatscreen());
      },
      subtitle: Text(message),
      trailing: Text(time),
    );
  }
}
