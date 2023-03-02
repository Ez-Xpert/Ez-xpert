import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class CallScheduleRepo {
  factory CallScheduleRepo(Dio dio) = _CallScheduleServices;
  Future<dynamic> getCallSchedule();
}

class _CallScheduleServices implements CallScheduleRepo {
  _CallScheduleServices(this._dio);
  final Dio _dio;

  @override
  Future getCallSchedule() async {
    try {
      var res = await _dio.get(ApiConfig.getCallSchedule);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
