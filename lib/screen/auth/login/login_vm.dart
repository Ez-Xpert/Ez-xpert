import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/home_main/home_page.dart';
import 'package:ez_xpert/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/user_model.dart';

class LoginVM extends BaseViewModel {
  @override
  void onInit() {}
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  String? email, password, fcmKey;
  // Firebase.initializeApp();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // String fcmToken = awa
  void visiblePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void login() async {
    final preference = await SharedPreferences.getInstance();
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showLoading();
      print(preference.getString('fcmToken').toString());
      final response = await api.authRepo.login(
          email!, password!, preference.getString('fcmToken').toString());
      log("e///${response.data}");
      if (response.runtimeType == Response) {
        if (response.data['success'] == "true" ||
            response.data['success'] == true) {
          prefs.token = response.data['data']['token'].toString();
          preference.setString("token", response.data['data']['token']);
          preference.setInt("user_id", response.data['data']['id']);
          preference.setString("user_name", response.data['data']['name']);
          preference.setString(
              "user_photo", response.data['data']['profile_photo_path']);
          preference.setString("firstTime", "no");
          try {
            prefs.user = UserModel.fromJson(response.data['data']);
          } catch (e) {
            log("error", error: e);
          }

          hideLoading();
          Navigator.pushAndRemoveUntil(
              MyApp.context,
              MaterialPageRoute(builder: (context) => const HomePageMain()),
              (route) => false);
        } else {
          EasyLoading.showToast(response.data['message']);
          hideLoading();
          //   showError(response.data['message'] ?? Messages.unknownError);
        }
      } else {
        hideLoading();
        showError(Messages.serverError);
      }
    }
  }
}
