import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/model/user_model.dart';
import 'package:ez_xpert/utils/formatter.dart';
import 'package:ez_xpert/utils/messages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProfileVM extends BaseViewModel {
  @override
  void onInit() {
    getProfile();
  }

  final formKey = GlobalKey<FormState>();
  UserModel? user;
  // String? dob;
  final TextEditingController dob = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController father = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobile = TextEditingController();

  File? profilePick;
  File? dLPick;
  File? tLPick;
  File? sInPick;

  void updaet() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // var body = user?.toJson();
      FormData formData = FormData();
      if (profilePick != null) {
        formData.files.add(
          MapEntry('photo', MultipartFile.fromFileSync(profilePick!.path)),
        );
      }

      if (dLPick != null) {
        formData.files.add(
          MapEntry('drivers_license', MultipartFile.fromFileSync(dLPick!.path)),
        );
      }
      if (tLPick != null) {
        formData.files.add(
          MapEntry('trade_license', MultipartFile.fromFileSync(tLPick!.path)),
        );
      }
      if (sInPick != null) {
        formData.files.add(
          MapEntry('sin_no', MultipartFile.fromFileSync(sInPick!.path)),
        );
      }
      formData.fields.addAll([
        MapEntry('name', user!.name.toString()),
       /* MapEntry('dob', user!.dob.toString()),
        MapEntry('father', user!.father.toString()),
        MapEntry('mobile', user!.mobile.toString()),*/
        MapEntry('email', user!.email.toString()),
      ]);
      showLoading();
      final response = await api.userRepo.updateProfile(formData);
      hideLoading();
      if (response.runtimeType == Response) {
        if (response.data['sucess'] == "true" ||
            response.data['sucess'] == true) {
          showNotification("Update Succes");
          dLPick = null;
          profilePick = null;
          sInPick = null;
          tLPick = null;
          notifyListeners();
          getProfile();
        } else {
          showError("Error update");
        }
      } else {
        showError(Messages.unknownError);
      }
    }
    notifyListeners();
  }

  void selectDob() async {
    DateTime? date = await showDatePicker(
      context: MyApp.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    dob.text = CustomFormat.formatDate(date);
    notifyListeners();
  }

  String imageUrl =
      "https://www.shareicon.net/data/512x512/2016/05/24/770137_man_512x512.png?123";

  String dimage =
      "https://img.freepik.com/free-vector/illustration-document-icon_53876-28510.jpg?size=626&ext=jpg";

  void getProfile() async {
    showLoading();
    final response = await api.profileRepo.getProfile();
    if (response.runtimeType == Response) {
      user = UserModel.fromJson(response.data['result']);
      name.text = user?.name ?? "";
      father.text = user?.father ?? "";
      email.text = user?.email ?? "";
      mobile.text = user?.mobile.toString() ?? "";
      dob.text = user?.dob.toString() ?? "";
      notifyListeners();
      if (user?.driversLicense.toString().isEmpty == true) {
        user?.driversLicense = null;
      }
      if (user?.tradeLicense.toString().isEmpty == true) {
        user?.tradeLicense = null;
      }
      if (user?.photo.toString().isEmpty == true) {
        user?.photo = null;
      }
      prefs.user = user;
      notifyListeners();
    } else {
      showError(Messages.serverError);
    }
    hideLoading();
  }

  void pickProfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      profilePick = File(result.files.single.path!);
      notifyListeners();
    } else {}
  }

  void pickDl() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      dLPick = File(result.files.single.path!);
      notifyListeners();
    } else {}
  }

  void pickTl() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      tLPick = File(result.files.single.path!);
      notifyListeners();
    } else {}
  }

  void pickSin() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      sInPick = File(result.files.single.path!);
      notifyListeners();
    } else {}
  }
}
