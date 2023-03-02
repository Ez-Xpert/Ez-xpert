import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class AuthRepo {
  factory AuthRepo(Dio dio) = _AuthServices;
  Future<dynamic> login(String email, String password, String fcm_id);
  Future<dynamic> signup(
      String email, String password, String name, String address);
}

class _AuthServices implements AuthRepo {
  _AuthServices(this._dio);
  final Dio _dio;

  @override
  Future login(String email, password, String fcm_id) async {
    try {
      FormData body = FormData();
      body.fields.addAll(
        [
          MapEntry('email', email),
          MapEntry('password', password),
          MapEntry('fcm_id', fcm_id),
        ],
      );
      var res = await _dio.post(ApiConfig.login, data: body);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }

  @override
  Future signup(
      String email, String password, String name, String address) async {
    try {
      FormData body = FormData();
      body.fields.addAll(
        [
          MapEntry('email', email),
          MapEntry('password', password),
          MapEntry('name', name),
          MapEntry('address', address),
        ],
      );
      var res = await _dio.post(ApiConfig.signup, data: body);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
