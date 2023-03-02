import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/onboarding_screen.dart';
import 'package:ez_xpert/screen/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../main.dart';
import '../../../utilities/styles.dart';
import '../../home_main/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with BasePage<LoginVM> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    return builder(
      () => Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: (MediaQuery.of(context).size.height),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.4, 0.7, 0.9],
                      colors: [
                        Color(0xFF1C2270),
                        Color(0xFF4563DB),
                        Color(0xFF1C2270),
                        Color(0xFF5B16D0),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Image.asset(
                          "assets/login_gif.gif",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 30,
                  child: Container(
                    height: (MediaQuery.of(context).size.height),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Form(
                      key: provider!.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(language!.log_text1,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 23.0,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w900,
                                height: 1.6,
                              )),
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            cursorColor: Colors.black,
                            cursorHeight: 18,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              provider!.email = newValue;
                            },
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black45, width: 1.4)),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              contentPadding: const EdgeInsets.all(5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: language!.log_text2,
                            ),
                          ),
                          const SizedBox(height: 35),
                          TextFormField(
                            obscureText: provider!.obscureText,
                            cursorColor: Colors.black,
                            cursorHeight: 18,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.black),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black45, width: 1.4)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  provider!.visiblePassword();
                                },
                                icon: Icon(
                                    provider!.obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black),
                              ),
                              contentPadding: const EdgeInsets.all(8.0),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                ),
                              ),
                              hintText: language!.log_text3,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.toString().length < 6) {
                                return 'Password must contain at least six characters!';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              provider!.password = newValue;
                            },
                          ),
                          const SizedBox(height: 50),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 50,
                            color: const Color(0xFF1C2270),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onPressed: () {
                              /* Navigator.pushReplacement(context, MaterialPageRoute(builder:
                                        (context) =>  HomePageMain())
                                    );*/

                              provider!.login();
                            },
                            child: Text(
                              language!.log_text1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 17.0,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginVM create() => LoginVM();

  @override
  void initialise(BuildContext context) {}
}
