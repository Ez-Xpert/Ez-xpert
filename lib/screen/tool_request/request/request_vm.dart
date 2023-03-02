import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/model/tool_model.dart';
import 'package:ez_xpert/utils/formatter.dart';
import 'package:ez_xpert/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToolRequestPopupVM extends BaseViewModel {
  @override
  void onInit() {}

  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  List<ToolModel>? tools;
  ToolModel? selectedTool;
  String? reason;

  selectTool(ToolModel? newTool) {
    selectedTool = newTool;
     print("tool id-->"+selectedTool!.id.toString());
  }

  void setReason(String? newvalue) {
    reason = newvalue;
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
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getInt("user_id");
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showLoading();
      final response = await api.toolRepo.requestTool(
          selectedTool?.id.toString() ?? "",
          startDate.text,
          endDate.text,
          reason.toString());
      hideLoading();
      if (response.runtimeType == Response) {
        if (response.data['sucess'] == true ||
            response.data['sucess'] == "true") {
          Navigator.pop(MyApp.context, true);
          showNotification("Tool Requested");
        } else {
          showError(response.data['message'] ?? Messages.unknownError);
        }
      } else {
        changeState(ChangeState.serverError);
      }
    }
  }
}
