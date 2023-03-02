import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/utils/formatter.dart';
import 'package:ez_xpert/utils/messages.dart';
import 'package:flutter/material.dart';

import '../../../api/api_config.dart';

class LeaveRequestVm extends BaseViewModel {
  @override
  void onInit() {}

  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  String? reason;
  String? type;

  void setType(String? newType) {
    type = newType;
    log(type.toString());
  }

  void setReason(String? newReason) {
    reason = newReason;
  }

  void selectStartDate() async {
    DateTime? date = await showDatePicker(
      context: MyApp.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    startDate.text = CustomFormat.formatDate(date);
    notifyListeners();
  }

  void selectEndDate() async {
    DateTime? date = await showDatePicker(
      context: MyApp.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    endDate.text = CustomFormat.formatDate(date);
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();
  void saveRequest() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showLoading();
      // await Future.delayed(const Duration(seconds: 2));

      var response = await api.leaveRepo
          .allLeave(startDate.text, endDate.text, type!, reason!);
      hideLoading();
      print("leave"+response.toString());

      if (response.data['sucess'] == "true" ||
          response.data['sucess'] == true) {
        Navigator.pop(MyApp.context, true);
        showNotification("Leave Saved");
      } else {
        Navigator.pop(MyApp.context, false);
        showError(response.data['message'] ?? Messages.unknownError);
      }
    }
  }
}
