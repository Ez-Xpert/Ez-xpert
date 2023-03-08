import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';
import 'package:ez_xpert/api/attendance_service.dart';
import 'package:ez_xpert/api/auth_services.dart';
import 'package:ez_xpert/api/knowledge_service.dart';
import 'package:ez_xpert/api/leave_services.dart';
import 'package:ez_xpert/api/notice_service.dart';
import 'package:ez_xpert/api/pay_roll_services.dart';
import 'package:ez_xpert/api/profile_services.dart';
import 'package:ez_xpert/api/tool_services.dart';
import 'package:ez_xpert/api/user_services.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/auth/login/login_screen.dart';
import 'package:ez_xpert/utils/locator.dart';
import 'package:ez_xpert/utils/share_prefs.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'call_schedule_services.dart';

class ApiClient {
  final _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {
        HttpHeaders.acceptHeader: "accept: application/json",
      },
      validateStatus: (status) {
        return status! < 500;
      },
    ),
  );
  late AuthRepo authRepo;
  late ProfileRepo profileRepo;
  late UserRepo userRepo;
  late ToolRepo toolRepo;
  late LeaveRepo leaveRepo;
  late NoticeRepo noticeRepo;
  late PayRollRepo payRollRepo;
  late KnowledgeRepo knowledgeRepo;
  late CallScheduleRepo callScheduleRepo;
  late AttendanceRepo attendanceRepo;
  ApiClient() {
    _dio.interceptors.add(
      PrettyDioLogger(
        responseHeader: true,
        requestHeader: true,
        requestBody: true,
        request: true,
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options,
            RequestInterceptorHandler requestInterceptorHandler) async {
          final prefs = locator<SharedPrefs>();
          if (prefs.token != null) {
            options.headers['Authorization'] = 'Bearer ${prefs.token}';
          }
          return requestInterceptorHandler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          if (response.data is String) {
            final jsonResponse = jsonDecode(response.data);
            response.data = jsonResponse;
          }
          if (response.statusCode == 401 &&
              response.data['message'] == "Unauthenticated.") {
            try {
              final prefs = locator<SharedPrefs>();
              prefs.removeAll();
              // Navigator.of(MyApp.context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (_) => const LoginScreen()),
              //     (route) => false);
            } catch (e) {
              log("error Logout", error: e);
            }
          } else {
            return handler.next(response);
          }
        },
        onError: (
          DioError error,
          ErrorInterceptorHandler handler,
        ) async {
          log('DioError, $error');
          return handler.next(error);
        },
      ),
    );

    authRepo = AuthRepo(_dio);
    profileRepo = ProfileRepo(_dio);
    userRepo = UserRepo(_dio);
    toolRepo = ToolRepo(_dio);
    leaveRepo = LeaveRepo(_dio);
    noticeRepo = NoticeRepo(_dio);
    payRollRepo = PayRollRepo(_dio);
    knowledgeRepo = KnowledgeRepo(_dio);
    callScheduleRepo = CallScheduleRepo(_dio);
    attendanceRepo = AttendanceRepo(_dio);
  }
}
