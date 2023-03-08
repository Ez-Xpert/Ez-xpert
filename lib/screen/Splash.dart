import 'dart:async';

import 'package:ez_xpert/onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/locator.dart';
import '../utils/share_prefs.dart';
import 'auth/login/login_screen.dart';
import 'home_main/home_page.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    get();
    super.initState();
  }

  get() async {
    await locator<SharedPrefs>().init();
    Timer(
        const Duration(seconds: 5),
        () => {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder:
              //   (context) => locator<SharedPrefs>().isLogin ? const HomePageMain():
              //   locator<SharedPrefs>().isFirstTIme ? const LoginScreen() : OnboardingScreen())
              // )
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFFFFF),
                Color(0xFFFFFFFF),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 150, horizontal: 80),
              child: Center(
                child: Image.asset(
                  "assets/splash.png",
                  fit: BoxFit.cover,
                  //height: 200,
                  //width: 150,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    /*return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 150,horizontal: 80),
          child: Center(
            child: Image.asset(
              "assets/splash.png",
              fit: BoxFit.cover,
              //height: 200,
              //width: 150,
            ),
          ),
        ),
      ),
    );*/
  }
}
