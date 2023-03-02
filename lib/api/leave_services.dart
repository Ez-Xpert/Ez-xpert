import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class LeaveRepo {
  factory LeaveRepo(Dio dio) = _LeaveServices;
  Future<dynamic> getLeaveData();
  Future<dynamic> allLeave(
      String startDate, String endDate, String type, String reason);
}

class _LeaveServices implements LeaveRepo {
  _LeaveServices(this._dio);
  final Dio _dio;

  @override
  Future getLeaveData() async {
    try {
      var res = await _dio.post(ApiConfig.getLeave);
      print("getallleave--->"+res.data.toString());
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }

  @override
  Future allLeave(
    String startDate,
    String endDate,
    String type,
    String reason,
  ) async {
    FormData formData = FormData();
    formData.fields.addAll(
      [
        MapEntry('start_date', startDate),
        MapEntry('end_date', endDate),
        MapEntry('leave_type', type),
        MapEntry('reason', reason),
      ],
    );
    try {
      var res = await _dio.post(ApiConfig.addLeave, data: formData);
      print("allleave--->"+res.data.toString());
      return res;
    } catch (e) {
      log("error api call login", error: e.toString());
      return false;
    }
  }
}
