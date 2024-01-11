import 'dart:developer';
import 'package:chatapp/controller/firebase_server_controller.dart';
import 'package:chatapp/controller/firestore_user_controller.dart';
import 'package:chatapp/controller/internet_speed.dart';
import 'package:chatapp/controller/theme_controller.dart';
import 'package:chatapp/views/change_language.dart';
import 'package:chatapp/views/custom_tab_label.dart';
import 'package:chatapp/views/server_down.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List resultUser = [];
  String loginUser = "";
  String loginEmail = "";
  String loginUserid = "";
  final TextEditingController _searchController = TextEditingController();
  List filteredUser = [];
  late FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;
  String name = "";
  late ThemeController themeController;
  late bool server_status = false;
  late Internetspeed internetspeed;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('user_email');
    String? nameValue = prefs.getString('user_name');
    String? userValue = prefs.getString("user_id");
    setState(() {
      loginUser = nameValue.toString();
      loginEmail = stringValue.toString();
      loginUserid = userValue.toString();
    });
    log(loginUser);
    log("name" + loginUser);
    log("email" + loginEmail);
    log("user_id" + loginUserid);
  }

  user_properties() async {
    log("user_properties");
    await mFirebaseAnalytics.setUserProperty(
        name: "logged_user_name", value: loginUser);
    await mFirebaseAnalytics.setUserProperty(
        name: "logged_user_email", value: loginEmail);
    await mFirebaseAnalytics.setUserProperty(
        name: "logged_user_id", value: loginUserid);
    log("/user_properties");
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    get_server();
    fetchUser();
    getStringValuesSF();
    mFirebaseAnalytics.setCurrentScreen(screenName: "Chat Screen");
    user_properties();
    themeController = Get.put(ThemeController());
    internetspeed = Get.put(Internetspeed());
    internet_speed();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  fetchUser() async {
    dynamic resultant = await UserFirestoreDb.getUsers();
    if (resultant == null) {
      log("no users found");
    } else {
      setState(() {
        resultUser = resultant;
      });
      log("users" + resultUser.toString());
    }
  }

  user_on_click_event() async {
    log("start");
    await mFirebaseAnalytics.logEvent(name: "chat");
    log("end");
  }

  get_server() async {
    dynamic resultant = await Serverdb.getTime();
    server_status = resultant;
    log("server_check$resultant");
    if (server_status == true) {
      Get.to(() => serverDown());
    }
  }

  internet_speed() async {
    await internetspeed.setBestServers();
  }

  List<String> items = ["All", "Friend", "Buddy"];

  int current = 0;

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 230,
                width: Get.width,
                color: themeController.theme.primaryColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              'chat_page_text'.tr + " " + loginUser,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: themeController.theme.primaryColor,
                            child: IconButton(
                              onPressed: () async {
                                themeController.toggleTheme();
                                setState(() {});
                                log("theme_change");
                              },
                              icon: Image.asset('assets/images/theme_icon.png'),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: themeController.theme.primaryColor,
                            child: IconButton(
                              onPressed: () async {
                                Get.to(() => language_change());
                                log("change_language");
                              },
                              icon: Image.asset(
                                'assets/images/language_icon.png',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _searchController,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            filteredUser = resultUser
                                .where((Userlist) =>
                                    Userlist['Name'].contains(value))
                                .toList();
                            log("filteredUser" + filteredUser.toString());
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'chat_page_search'.tr,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.search_sharp,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              log("hi");
                            },
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Colors.transparent,
                ),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 0.0),
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  CustomTab(text: 'All'),
                  CustomTab(text: 'Friends'),
                  CustomTab(text: 'Buddies'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      color: Colors.white70,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: _searchController.text.isEmpty
                            ? resultUser.length
                            : filteredUser.isNotEmpty
                                ? filteredUser.length
                                : 1,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          if (_searchController.text.isEmpty ||
                              filteredUser.isNotEmpty) {
                            final user = _searchController.text.isEmpty
                                ? resultUser[index]
                                : filteredUser[index];
                            name = _searchController.text.isEmpty
                                ? user['Name']
                                : filteredUser[index]['Name'];
                            String userId = user['user_id'];

                            return GestureDetector(
                              onTap: () async {
                                await user_on_click_event();
                                await Get.to(
                                  chatscreen(),
                                  arguments: {
                                    'user_name': user['Name'],
                                    'user_id': user['user_id'],
                                    'login_user_name': loginUser,
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 10,
                                  bottom: 10,
                                ),
                                height: 70,
                                width: Get.width,
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(5),
                                // ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        "assets/images/status_image.png",
                                      ),
                                      maxRadius: 30,
                                    ),
                                    SizedBox(width: 16),
                                    Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user['Name'].toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            userId.toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 200,
                                    ),
                                    Text(
                                      "No User Found",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        "Status Pages",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Calls Page',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
