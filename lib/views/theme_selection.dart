// import 'dart:developer';
//
// import 'package:chatapp/views/login.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controller/theme_controller.dart';
//
// class ThemePage extends StatefulWidget {
//   const ThemePage({Key? key}) : super(key: key);
//
//   @override
//   _ThemePageState createState() => _ThemePageState();
// }
//
// class _ThemePageState extends State<ThemePage> {
//   late String selectedRadio;
//   late ThemeController themeController;
//
//   @override
//   void initState() {
//     super.initState();
//     themeController = Get.put(ThemeController());
//     selectedRadio = themeController.isDarkMode ? "Dark" : "Light";
//   }
//
//   setSelectedRadio(String val) {
//     setState(() {
//       selectedRadio = val;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: Get.width,
//         color: themeController.isDarkMode ? Colors.black : Colors.white,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 250,
//             ),
//             Text(
//               "Please select Theme",
//               style: TextStyle(
//                 color: themeController.isDarkMode
//                     ? Colors.white
//                     : Colors.black,
//                 fontSize: 30,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Radio(
//                   value: "Light",
//                   groupValue: selectedRadio,
//                   onChanged: (val) {
//                     log(val.toString());
//                     setSelectedRadio(val.toString());
//                   },
//                   activeColor: Colors.blue,
//                 ),
//                 Text(
//                   "Light",
//                   style: TextStyle(
//                     color: themeController.isDarkMode
//                         ? Colors.white
//                         : Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Radio(
//                   value: "Dark",
//                   groupValue: selectedRadio,
//                   onChanged: (val) {
//                     log(val.toString());
//                     setSelectedRadio(val.toString());
//                   },
//                   activeColor: Colors.blue,
//                 ),
//                 Text(
//                   "Dark",
//                   style: TextStyle(
//                     color: themeController.isDarkMode
//                         ? Colors.white
//                         : Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 log("change_theme");
//                 themeController.toggleTheme();
//                 Get.to(() => Login());
//               },
//               style: TextButton.styleFrom(
//                 textStyle: const TextStyle(
//                   fontSize: 20,
//                 ),
//                 backgroundColor: Colors.blue,
//                 fixedSize: const Size(350, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 "Submit",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 20,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
