import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/formatter.dart';

class CheckInOutVM extends BaseViewModel {
  int? user_id;
  var token;
  @override
  void onInit() {
    getUserId();
    // getLeave();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    //user_name = prefs.getString("user_name");
    token = prefs.getString("token");
    print("token::::::=>" + token.toString());
    getAttendance(user_id);
  }

  DateTime? checkinTime;
  String dailycheckin = '';
  String dailycheckout = '';
  bool emer = false;
  bool checkEmerStart = false;
  String currentDay = '';
  onChangedCheckInOut(){
    dailycheckin= '';
    dailycheckout = '';
  }

  void checkinOrCheckout(var id) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    FormData formData = FormData();
    formData.fields.addAll(
      [
        MapEntry(
          'user_id',
          id.toString(),
        ),
      ],
    );
    headers.addAll(headers);
    if (dailycheckin == null) {
      print('if....');
      showLoading();
      final response = await api.attendanceRepo.checkInOut(formData);
      hideLoading();
      if (response.runtimeType == Response) {
        dailycheckin =
            CustomFormat.formatTime(DateTime.parse(response.data['data']))
                .toString();
        getAttendance(user_id);
        print("dailycheckin..$dailycheckin");
        notifyListeners();
      } else {
        changeState(ChangeState.serverError);
      }
    } else {
      print('else....');
      showLoading();
      final response = await api.attendanceRepo.checkInOut(formData);
      hideLoading();
      if (response.runtimeType == Response) {
        dailycheckout =
            CustomFormat.formatTime(DateTime.parse(response.data['data']))
                .toString();
        getAttendance(user_id);
        print("dailycheckout..$dailycheckout");
        notifyListeners();
      } else {
        changeState(ChangeState.serverError);
      }
    }
  }

  emerCheckinOut(var id) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    FormData formData = FormData();
    formData.fields.addAll([
      MapEntry('user_id', id.toString()),
    ]);
    headers.addAll(headers);
    showLoading();
    final response = await api.attendanceRepo.emergCheckInOut(formData);
    hideLoading();
    if (response.runtimeType == Response) {
      emer = !emer;
      getAttendance(id);
      notifyListeners();
      if (emer == false) {
        getAttendance(id);

        notifyListeners();
      }
      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
  }

  List attendance = [];
  List emergencyWork = [];
  List dailyreport = [];
  void getAttendance(var id) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    FormData formData = FormData();
    formData.fields.addAll([
      MapEntry('user_id', id.toString()),
    ]);
    headers.addAll(headers);
    showLoading();
    final response = await api.userRepo.getAttendance(formData);
    hideLoading();

    if (response.runtimeType == Response) {
      attendance = response.data['data']['attendance_details'] ?? [];
      if(attendance.isNotEmpty){
        currentDay= attendance[0]['date'];
      }
      emergencyWork = response.data['data']['emergency_report'] ?? [];
      dailyreport = response.data['data']['daily_report'] ?? [];
      log("res...${json.encode(response.data['data'])}");
      if (emergencyWork.isNotEmpty) {
        if (emergencyWork[0]['from_time'] != null &&
            emergencyWork[0]['to_time'] != null &&
            emergencyWork[0]['from_time'] != '' &&
            emergencyWork[0]['to_time'] != '') {
          checkEmerStart = false;
        } else if (emergencyWork[0]['from_time'] != null ||
            emergencyWork[0]['from_time'] != '') {
          checkEmerStart = true;
        }
        notifyListeners();
      }
      try {
        if (attendance.where((element) {
          return element['work_in']
              .toString()
              .contains(DateTime.now().toString().substring(0, 9));
        }).isNotEmpty) {
          // dailycheckin = DateTime.parse(attendance.last['work_in']);
          dailycheckin = dailyreport.last['work_in'];
          //dailycheckin=CustomFormat.formatTime(DateTime.parse(dailyreport.last['work_in']));
          // if (attendance.last['work_in'] != attendance.last['work_out']) {
          // if (dailyreport.last['work_in'] != dailyreport.last['work_out']) {
          // dailycheckout = DateTime.parse(attendance.last['work_out']);
          dailycheckout = dailyreport.last['work_out'];
          print("dailycheckoutdgdg...$dailycheckout");
          //dailycheckout=CustomFormat.formatTime(DateTime.parse(dailyreport.last['work_out']));
          sellHour = dailyreport.last[' '];
          notifyListeners();
          print(sellHour);
          // dailycheckout = DateTime.parse(dailyreport.last['work_out']);
          // }
        }
      } catch (e) {
        log("error check in out", error: e);
      }
      try {
        if (emergencyWork.last['from_time'] == emergencyWork.last['to_time']) {
          emer = true;
          notifyListeners();
        }
      } catch (e) {
        log("error check in out", error: e);
      }

      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
  }

  var sellHour;
  void getLeave() async {
    showLoading();
    final response = await api.leaveRepo.getLeaveData();
    hideLoading();
    if (response.runtimeType == Response) {
      // sellHour = response.data['result']['sell_hour'];
      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
  }
}
