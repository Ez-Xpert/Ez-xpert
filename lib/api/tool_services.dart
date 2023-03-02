import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class ToolRepo {
  factory ToolRepo(Dio dio) = _ToolServices;
  Future<dynamic> getTools();
  Future<dynamic> requestTool(
    String toolId,
    String startDate,
    String endDate,
    String reason,
  );
}

class _ToolServices implements ToolRepo {
  _ToolServices(this._dio);
  final Dio _dio;

  @override
  Future getTools() async {
    try {
      var res = await _dio.post(ApiConfig.tool_request_list);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }

  @override
  Future requestTool(
    String toolId,
    String startDate,
    String endDate,
    String reason,
  ) async {
    try {
      FormData body = FormData();
      body.fields.addAll(
        [
          MapEntry('tool_id', toolId),
          MapEntry('from_date', startDate),
          MapEntry('to_date', endDate),
          MapEntry('reason', reason),
        ],
      );
      var res = await _dio.post(ApiConfig.requestTool, data: body);
      return res;
    } catch (e) {
      return false;
    }
  }
}
