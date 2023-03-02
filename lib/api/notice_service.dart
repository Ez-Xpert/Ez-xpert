import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class NoticeRepo {
  factory NoticeRepo(Dio dio) = _NoticeServices;
  Future<dynamic> getNotice();
}

class _NoticeServices implements NoticeRepo {
  _NoticeServices(this._dio);
  final Dio _dio;

  @override
  Future getNotice() async {
    try {
      var res = await _dio.get(ApiConfig.getnotice);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
