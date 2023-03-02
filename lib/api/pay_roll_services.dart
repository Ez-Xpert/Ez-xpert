import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class PayRollRepo {
  factory PayRollRepo(Dio dio) = _PayRollServices;
  Future<dynamic> getPayRoll();
}

class _PayRollServices implements PayRollRepo {
  _PayRollServices(this._dio);
  final Dio _dio;

  @override
  Future getPayRoll() async {
    try {
      var res = await _dio.get(ApiConfig.getPayRoll);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
