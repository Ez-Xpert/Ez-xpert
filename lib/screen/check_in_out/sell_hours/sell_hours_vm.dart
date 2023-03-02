import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/utils/formatter.dart';
import 'package:ez_xpert/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellHoursVm extends BaseViewModel {

  int? user_id;
  @override
  void onInit() {
    getUserId();
  }
  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    //user_name = prefs.getString("user_name");
    getData();
  }
  // List<LeaveModels>? leavelist;
  String? sellHours;
  String? totalworkingHours;
  String? effeciecy;
  String? isEffecient;
  var over_time;

  void setHours(String? hours) {
    sellHours = hours;
    print(sellHours);
    geteffeciencydata();
  }
  void setTotalWorkingHours(String? hours) {
    totalworkingHours = hours;
  }


  final formKey = GlobalKey<FormState>();

  void geteffeciencydata() async {
    print("geteffeciencydata-->"+totalworkingHours.toString());
    print("geteffeciencydata-->"+sellHours.toString());
    print("geteffeciencydata-->"+user_id.toString());
    print("geteffeciencydata-->"+over_time.toString());
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showLoading();
      var response = await api.userRepo.CalcEffecience(totalworkingHours.toString(), sellHours.toString(),over_time!.toString());
      hideLoading();

      if (response.data['success'] == "true" || response.data['success'] == true) {
        effeciecy = response.data['data']['efficiency'].toString();

        isEffecient = response.data['data']['is_efficient'];
        showError(response.data['message']);

      } else {
        Navigator.pop(MyApp.context, false);
        showError(response.data['message'] ?? Messages.unknownError);
      }
    }
    notifyListeners();
  }
  void addSellHour() async {

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showLoading();
      Response response = await api.userRepo
          .AddSellHour(totalworkingHours, sellHours, effeciecy, isEffecient,user_id);
      hideLoading();

      if (response.data['sucess'] == "true" ||
          response.data['sucess'] == true) {
        Navigator.pop(MyApp.context, true);
        showNotification("Sell Hour Updated");

      } else {
        Navigator.pop(MyApp.context, false);
        showError(response.data['message'] ?? Messages.unknownError);
      }
    }
    notifyListeners();
  }

  List attendance = [];
  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    FormData formData = FormData();
    formData.fields.addAll([
      MapEntry('user_id', user_id.toString()),
    ]);
    headers.addAll(headers);
    showLoading();
    final response = await api.userRepo.getAttendance(formData);
    hideLoading();
    if (response.runtimeType == Response) {
      attendance = response.data['data']['attendance_details'] ?? [];

      try {
        if (attendance.where((element) {
          return element['work_in']
              .toString()
              .contains(DateTime.now().toString().substring(0, 9));
        }).isNotEmpty) {

          totalworkingHours = attendance.first['hours'].toString();
          over_time = attendance.first['ot_hr'];

          // if (attendance.last['work_in'] != attendance.last['work_out']) {
          //   checkOutTime = DateTime.parse(attendance.last['work_out']);
          // }
        }
      } catch (e) {
        log("error check in out", error: e);
      }


      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
    //totalworkingHours="3";
  }
}
