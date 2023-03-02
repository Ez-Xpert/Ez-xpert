import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRepo {
  factory UserRepo(Dio dio) = _UserServices;
  Future<dynamic> getUserData();
  Future<dynamic> getAttendance(FormData body);
  Future<dynamic> getAttend();
  Future<dynamic> updateProfile(FormData body);
  Future<dynamic> CalcEffecience(
      String workedHour, String sellHour, var over_time);
  Future<dynamic> AddSellHour(
      var workedHour, var sellHour, var efficency, var isEfficent,var id);
}

class _UserServices implements UserRepo {
  _UserServices(this._dio);
  final Dio _dio;

  @override
  Future getUserData() async {
    try {
      var res = await _dio.get(ApiConfig.getUserData);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }

  @override
  Future getAttendance(FormData body) async {
    try {
      var res = await _dio.post(ApiConfig.getattendance,data: body);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
  @override
  Future getAttend() async {
    try {
      var res = await _dio.get(ApiConfig.getattend);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }

  @override
  Future updateProfile(FormData body) async {
    try {
      var res = await _dio.post(ApiConfig.updateProfile, data: body);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
  @override
  Future CalcEffecience(
      var workedHour,
      var sellHour,
      var over_time,
      ) async {
    FormData formData = FormData();
    final prefs = await SharedPreferences.getInstance();

   var token = prefs.getString("token");
    print("token::::::=>"+token.toString());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    formData.fields.addAll(
      [
        MapEntry('worked_hour', workedHour),
        MapEntry('sell_hour', sellHour),
        MapEntry('over_time', over_time),
      ],
    );
    headers.addAll(headers);

    try {
      var res = await _dio.post(ApiConfig.calcEffecience, data: formData);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }

  @override
  Future AddSellHour(
      var workedHour,
      var sellHour,
      var efficency,
      var isEfficent,
      var id,
      ) async {
    FormData formData = FormData();
    formData.fields.addAll(
      [
        MapEntry('worked_hour', workedHour),
        MapEntry('sell_hour', sellHour),
        MapEntry('efficency', efficency),
        MapEntry('is_efficent', isEfficent),
      ],
    );
    try {
      var res = await _dio.post(ApiConfig.addSellHour, data: formData);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
