import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class AttendanceRepo {
  factory AttendanceRepo(Dio dio) = _AttendanceServices;
  Future<dynamic> checkInOut(FormData body);
  Future<dynamic> emergCheckInOut(FormData body);
}

class _AttendanceServices implements AttendanceRepo {
  _AttendanceServices(this._dio);
  final Dio _dio;

  @override
  Future checkInOut(FormData body) async {
    try {
      var res = await _dio.post(ApiConfig.attendanceInOut,data: body);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }

  @override
  Future emergCheckInOut(FormData body) async {
    try {
      var res = await _dio.post(ApiConfig.emerAttendanceInOut,data: body);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
