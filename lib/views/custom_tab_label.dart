import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTab extends StatelessWidget {
  final String text;

  const CustomTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,),
            ),
          )
        ],
      ),
    );
  }
}
