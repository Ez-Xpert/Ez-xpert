import 'dart:convert';
import 'dart:developer';

import 'package:ez_xpert/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String tokenKey = 'tokenkey';
  static const String userIdKey = 'userId';
  static const String userKey = 'user';

  SharedPreferences? _prefs;

  Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //Token
  String? get token => _prefs!.getString(tokenKey);
  String? get firstTime => _prefs!.getString("firstTime");

  set token(String? token) {
    _prefs?.setString(tokenKey, token!);
  }

  bool get isLogin => token != null;
  bool get isFirstTIme => firstTime != null;

  void removeToken() {
    _prefs?.remove(tokenKey);
  }

  //user Id//
  String? get userId => _prefs!.getString(userIdKey);

  set userId(String? token) {
    _prefs?.setString(userIdKey, token!);
  }

  set firstTime(String? time) {
    _prefs?.setString("firstTime", time!);
  }

  void removeUserId() {
    _prefs?.remove(userIdKey);
  }

  // User //
  UserModel? get user {
    try {
      if (_prefs!.containsKey(userKey)) {
        final jsonData = jsonDecode(_prefs!.getString(userKey)!);
        return UserModel.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      log("error decode user prefs", error: e);
      return null;
    }
  }

  set user(UserModel? user) {
    _prefs!.setString(userKey, jsonEncode(user!.toJson()));
  }

  void removeUser() {
    _prefs!.remove(userKey);
  }

  //Remove all
  void removeAll() {
    removeToken();
    removeUserId();
    removeUser();
    _prefs!.setString("firstTime", "No");
  }
}
