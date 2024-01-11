import 'package:flutter/material.dart';

class no_internet extends StatefulWidget {
  const no_internet({super.key});

  @override
  State<no_internet> createState() => _no_internetState();
}

class _no_internetState extends State<no_internet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/no_network.png"),
            SizedBox(
              height: 30,
            ),
            Text(
              "No Internet",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Please Try Again",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
