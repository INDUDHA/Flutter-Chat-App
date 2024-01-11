import 'dart:convert';
import 'package:chatapp/views/chat.dart';
import 'package:chatapp/views/server_down.dart';
// import 'package:chatapp/views/get_api_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/firebase_server_controller.dart';
import '../controller/firestore_message_controller.dart';
import '../controller/theme_controller.dart';
import '../model/message.dart';
import 'dart:developer';

class chatscreen extends StatefulWidget {
  const chatscreen({super.key});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  String reciever = Get.arguments['user_name'].toString();
  String us = Get.arguments['user_id'].toString();
  // DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy,h:mm').format(DateTime.now());
  TextEditingController messagecontroller = TextEditingController();
  List result_messages = [];
  List result_messages1 = [];
  Map<String, dynamic> messages = {};
  Map<String, dynamic> resultTimeJson = {};
  late DateTime start_date = DateTime.now();
  late DateTime end_date = DateTime.now();
  late FocusNode focusNode;
  String loginUser = Get.arguments['login_user_name'].toString();
  late FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;
  late bool server_status = false;
  late ThemeController themeController;

  // final ApiService _apiService = ApiService();

  void clearText() {
    messagecontroller.clear();
  }

  void parseTimeValues() {
    if (resultTimeJson.containsKey('start') &&
        resultTimeJson.containsKey('end')) {
      start_date = DateTime.parse(resultTimeJson['start']);
      end_date = DateTime.parse(resultTimeJson['end']);
      log(start_date.toString());
      log(end_date.toString());
    } else {
      log('Start or end time is missing in resultTimeJson');
    }
  }

  get_server() async {
    dynamic resultant = await Serverdb.getTime();
    server_status = resultant;
    log("server_check$resultant");
    if (server_status == true) {
      Get.to(() => serverDown());
    }
  }

  fetchmessages() async {
    dynamic resultant = await MessageFirestoreDb.getUsers(
        from: 'Message_from',
        from_user: loginUser,
        to: 'Message_to',
        to_user: reciever);
    if (resultant == null) {
      log("no users found");
    } else {
      result_messages = resultant;
      for (var msg in result_messages) {
        messages[msg['MessageId']] = msg;
      }
      log("fetch_messages: " + messages.toString());
      log(loginUser);
      log(reciever);
    }
  }

  fetchmessages1() async {
    if (loginUser != null && reciever != null) {
      dynamic resultant = await MessageFirestoreDb.getUsers1(
          from: 'Message_from',
          from_user: loginUser,
          to: 'Message_to',
          to_user: reciever);
      if (resultant == null) {
        log("no users found");
      } else {
        result_messages1 = resultant;
        for (var msg in result_messages1) {
          messages[msg['MessageId']] = msg;
        }
        log("fetch_messages_1: " + messages.toString());
        log(loginUser);
        log(reciever);
      }
    } else {
      log("loginUser or reciever is null");
    }
  }

  fetchtime() async {
    dynamic resultant = await MessageFirestoreDb.getTime();
    if (resultant == null) {
      log("no time interval found");
    } else {
      if (resultant is String) {
        resultTimeJson = json.decode(resultant);
      } else if (resultant is Map<String, dynamic>) {
        resultTimeJson = Map<String, dynamic>.from(resultant);
      } else {
        log("Unexpected data type received from fetchtime");
      }
      log(resultTimeJson.toString());
    }
  }

  bool isDateInRange(
      DateTime currentDate, DateTime startDate, DateTime endDate) {
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }

  send_on_click_event() async {
    mFirebaseAnalytics = FirebaseAnalytics.instance;
    log("start");
    await mFirebaseAnalytics.logEvent(name: "send_on_click");
    log("end");
  }

  back_icon_onclick() async {
    mFirebaseAnalytics = FirebaseAnalytics.instance;
    log("start");
    await mFirebaseAnalytics.logEvent(name: "back_icon_on_click");
    log("end");
  }

  @override
  void initState() {
    super.initState();
    get_server();
    messagecontroller = TextEditingController();
    fetchmessages();
    fetchmessages1();
    fetchtime().then((_) {
      parseTimeValues();
      setState(() {});
    });
    mFirebaseAnalytics.setCurrentScreen(screenName: "Chat Screen");
    themeController = Get.put(ThemeController());
  }

  @override
  Widget build(BuildContext context) {
    bool shouldShowTimeButton =
        isDateInRange(DateTime.now(), start_date, end_date);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            height: 100,
            color: themeController.theme.primaryColor,
            margin: const EdgeInsets.only(
              top: 30,
            ),
            child: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                  onTap: () async {
                    await back_icon_onclick();
                    await Get.to(Chat());
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                // Image.asset('assets/images/status_image.png', height: 50),
                // CircleAvatar(
                //   child: Image.asset(
                //     'assets/images/status_image.png',
                //     height: 35,
                //   ),
                //   backgroundColor: Colors.black,
                // ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/images/status_image.png"))),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      reciever,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      us,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
                SizedBox(
                  width: 10,
                ),
                // const Icon(
                //   Icons.check_circle_outline,
                //   color: Colors.green,
                //   size: 15,
                // ),
                ElevatedButton(
                  onPressed: shouldShowTimeButton
                      ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Time Interval'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Start Date: ${start_date.toString()}'),
                                    Text('End Date: ${end_date.toString()}'),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      // Get.to(getapi());
                                    },
                                    child: const Text('Call Api'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    backgroundColor:
                        shouldShowTimeButton ? Colors.blue : Colors.grey,
                    // fixedSize: const Size(0, 20),
                  ),
                  child: const Text(
                    "Time",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var messageId = messages.keys.toList()[index];
                  var msg = messages[messageId];
                  return Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Image.asset(
                            'assets/images/status_image.png',
                            height: 35,
                          ),
                          backgroundColor: Colors.white,
                        ),
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          color: msg['Message_from'] == msg['Message_to']
                              ? themeController.theme.primaryColor
                              : null,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 30,
                                top: 10,
                                bottom: 20,
                              ),
                              child: Text(
                                msg['Message_from'],
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 30,
                                top: 25,
                                bottom: 20,
                              ),
                              child: Text(
                                msg['Text'],
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                right: 10,
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat('hh:mm').format(
                                        DateFormat('dd-MM-yyyy,h:mm')
                                            .parse(msg['Time']),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ))
                          ]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: themeController.theme.primaryColor,
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 5.0),
                    const Icon(Icons.insert_emoticon,
                        size: 30.0, color: Colors.white),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: TextField(
                        controller: messagecontroller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'chat_screen'.tr,
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.attach_file,
                        size: 30.0, color: Colors.white),
                    const SizedBox(width: 5.0),
                    const Icon(Icons.camera_alt,
                        size: 30.0, color: Colors.white),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () async {
                        final msgmodel = MessageModel(
                            Userid: us,
                            Text: messagecontroller.text,
                            Time: formattedDate,
                            Message_to: reciever,
                            Message_from: loginUser,
                            Username: loginUser);
                        MessageFirestoreDb.addUser(msgmodel);
                        log('Message Sent');
                        fetchmessages();
                        fetchmessages1();
                        clearText();
                        await send_on_click_event();
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.send),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
