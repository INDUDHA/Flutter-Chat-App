import 'package:flutter/material.dart';

class custom_story extends StatelessWidget {
  final String name;
  const custom_story({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 100,
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/status_image.png'),
          const SizedBox(height: 10),
          Text(
            (name),
            style: const TextStyle(
                fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
