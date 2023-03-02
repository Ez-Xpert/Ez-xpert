import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class ProfileRepo {
  factory ProfileRepo(Dio dio) = _ProfileServices;
  Future<dynamic> getProfile();
}

class _ProfileServices implements ProfileRepo {
  _ProfileServices(this._dio);
  final Dio _dio;

  @override
  Future getProfile() async {
    try {
      var res = await _dio.post(ApiConfig.getProfile);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
