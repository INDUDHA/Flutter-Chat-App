import 'package:flutter/material.dart';
import 'package:get/get.dart';

class serverDown extends StatefulWidget {
  const serverDown({super.key});

  @override
  State<serverDown> createState() => _serverDownState();
}

class _serverDownState extends State<serverDown> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child:Scaffold(
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/images/na_january_16.jpg'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Server Down",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20
                ),),
                SizedBox(
                  height: 30,
                ),
                Text("Please Try Again After Sometime",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.w500
                  ),
                )



              ],
            ),
          ),
        )
    );
  }
}
