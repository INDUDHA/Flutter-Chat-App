import 'dart:developer';
import 'package:chatapp/views/server_down.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../controller/firebase_server_controller.dart';
import '../controller/login_controller.dart';
import '../controller/sign_in_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/google_signin_controller.dart';
import '../controller/theme_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool passwordVisible = true;
  late LoginController loginController;
  late GController googleSignController;
  late SignUpController signUpController;
  String emailErrorText = '';
  bool emailHasFocus = false;
  bool passwordHasFocus = false;
  bool _load = false;
  late FirebaseAnalytics mFirebaseAnalytics = FirebaseAnalytics.instance;
  late bool server_status = false;
  late ThemeController themeController;


  get_server() async {
    dynamic resultant = await Serverdb.getTime();
    server_status = resultant;
    log("server_check$resultant");
    if(server_status == true){
      Get.to(() => serverDown());
    }
  }

  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  google_sign_in_event() async {
    log("start");
    await mFirebaseAnalytics.logEvent(name: "signup_g_event");
    log("end");
  }

  sign_in_event() async {
    log("start");
    await mFirebaseAnalytics.logEvent(name: "signup_s_event");
    log("end");
  }

  login_in_event() async {
    log("start");
    await mFirebaseAnalytics.logEvent(name: "login_l_event");
    log("end");
  }

  @override
  void initState() {
    super.initState();
    get_server();
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    loginController = Get.put(LoginController());
    googleSignController = Get.put(GController());
    // googleSignController = Get.lazyPut(() => GController());
    signUpController = Get.put(SignUpController());
    mFirebaseAnalytics.setCurrentScreen(
        screenName: "Login Page / Sign Up Page");
    themeController = Get.put(ThemeController());

  }

  // @override
  // void dispose() {
  //   emailcontroller.dispose();
  //   passwordcontroller.dispose();
  //   super.dispose();
  // }

  void clearText() {
    emailcontroller.clear();
    passwordcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                color: Colors.black,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 41),
                      child: Text(
                        "login_page_title".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 41),
                      child: TextField(
                        controller: emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            emailHasFocus = value.isNotEmpty;
                            emailErrorText = validateEmail(value)
                                ? ''
                                : 'login_page_email'.tr;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "login_page_email".tr,
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    emailHasFocus ? Colors.blue : Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    emailHasFocus ? Colors.blue : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 41),
                      child: TextField(
                        obscureText: passwordVisible,
                        controller: passwordcontroller,
                        keyboardType: TextInputType.visiblePassword,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            passwordHasFocus = value.isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "login_page_password".tr,
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: passwordHasFocus
                                    ? Colors.blue
                                    : Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: passwordHasFocus
                                    ? Colors.blue
                                    : Colors.grey),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await login_in_event();
                          loginController.signIn(
                              emailcontroller.text, passwordcontroller.text);
                          setState(() {
                            _load = true;
                          });
                        },
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 20,
                          ),
                          backgroundColor: Colors.white,
                          fixedSize: const Size(350, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          "login_page_b1".tr,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await sign_in_event();
                          signUpController.signUp(
                              emailcontroller.text, passwordcontroller.text);
                          setState(() {
                            _load = true;
                          });
                          // clearText();
                        },
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 20,
                          ),
                          backgroundColor: Colors.white,
                          fixedSize: const Size(350, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          "login_page_b2".tr,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                     Text(
                      "login_page_or".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () async {
                        await google_sign_in_event();
                        googleSignController.login(context);
                        setState(() {
                          _load = true;
                        });
                      },
                      child: Image.asset('assets/images/googleicon.png',
                          width: 50),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
