import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) =>
      Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  /// Login Page
  String get log_text1;

  String get log_text2;

  String get log_text3;

  /// Bottom Navigation Bar
  String get bn_text1;

  String get bn_text2;

  String get bn_text3;

  String get bn_text4;

  String get bn_text5;

  /// home
  String get home_text1;

  String get home_text2;

  String get home_text22;

  String get home_text3;

  String get home_text33;

  String get home_text4;

  String get home_text44;

  String get home_text5;

  String get home_text55;

  String get home_text6;

  String get home_text7;

  String get home_text8;

  String get home_text9;

  String get home_text10;

  /// check in out
  String get inout_text1;

  String get inout_text2;

  String get inout_text3;

  String get inout_text4;

  String get inout_text5;

  String get inout_text6;

  String get inout_text7;

  String get inout_text8;

  String get inout_text9;

  String get inout_text10;

  String get inout_text11;

  String get inout_text12;

  String get inout_text13;

  String get inout_text14;

  String get inout_text15;

  String get inout_text16;

  String get inout_text17;

  String get inout_text18;

  String get inout_text19;

  String get inout_text20;

  /// time sheet screen
  String get time_text1;

  String get time_text2;

  String get time_text3;

  String get time_text4;

  String get time_text5;

  String get time_text6;

  String get time_text7;

  String get time_text8;

  String get time_text9;

  /// leave
  String get leave_text1;

  String get leave_text2;

  String get leave_text3;

  String get leave_text4;

  String get leave_text5;

  String get leave_text6;

  String get leave_text7;

  String get leave_text8;

  String get leave_text9;

  String get leave_text10;

  String get leave_text11;

  String get leave_text12;

  /// tool
  String get tool_text1;

  String get tool_text2;

  String get tool_text3;

  String get tool_text4;

  String get tool_text5;

  String get tool_text6;

  String get tool_text7;

  String get tool_text8;

  String get tool_text9;

  String get tool_text10;

  String get tool_text11;

  /// dr
  String get dr_text1;

  String get dr_text2;

  String get dr_text3;

  String get dr_text4;

  String get dr_text5;

  String get dr_text6;

  String get dr_text7;

  String get dr_text8;

  String get dr_text9;

  String get dr_text10;

  String get dr_text11;

  String get dr_text12;

  /// pro
  String get pro_text1;

  String get pro_text2;

  String get pro_text3;

  String get pro_text4;

  String get pro_text5;

  String get pro_text6;

  String get pro_text7;

  String get pro_text8;

  String get pro_text9;

  String get pro_text10;

//employee_warning
  String get employee_warning1;

  String get employee_warning2;

  String get employee_warning3;

  String get employee_warning4;

  String get employee_warning5;
}
