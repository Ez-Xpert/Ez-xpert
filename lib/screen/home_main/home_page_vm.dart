import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/model/user_model.dart';
import 'package:ez_xpert/screen/call_schedule/call_schedule.dart';
import 'package:ez_xpert/screen/check_in_out/check_in_out.dart';
import 'package:ez_xpert/screen/home/home.dart';
import 'package:ez_xpert/screen/profile/profile.dart';
import 'package:ez_xpert/screen/time_sheet/time_sheet.dart';
import 'package:ez_xpert/screen/tool_request/tool_request.dart';
import 'package:ez_xpert/screen/vacation/vacation.dart';
import 'package:flutter/material.dart';

import '../new_time_sheet.dart';

class HomePageMainVM extends BaseViewModel {
  @override
  void onInit() {
    getuser();
  }

  int curentIndex = 0;
  String title = "Home";
  void changeIndex(val) {
    curentIndex = val;
    title = homeScreenTitles[val];
    notifyListeners();
  }

  void getuser() async {
    Response response = await api.profileRepo.getProfile();
    //UserModel user = UserModel.fromJson(response.data['result']);
    //prefs.user = user;
  }

  List<String> homeScreenTitles = [
    "Home",
    "Time sheet",
    "In/Out time",
    "Vacation",
    "Tool Request",
  ];

  Widget buildHome() {
    switch (curentIndex) {
      case 0:
        return Home(function: changeIndex);
      // case 1:
      //   return const CheckInOut();
      case 1:
        // title = 'Jobs';
        return const NewTimeSheet();

      case 2:
        // title = 'Jobs';
        return const CheckInOut();
      case 3:
        // title = 'Jobs';
        return const Vacation();
      case 4:
      // title = 'Jobs';
      // return const ToolRequest();
      default:
        return const Home();
    }
  }
}
