import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';

abstract class KnowledgeRepo {
  factory KnowledgeRepo(Dio dio) = _KnowledgeServices;
  Future<dynamic> getKnowledge();
}

class _KnowledgeServices implements KnowledgeRepo {
  _KnowledgeServices(this._dio);
  final Dio _dio;

  @override
  Future getKnowledge() async {
    try {
      var res = await _dio.get(ApiConfig.getKnowledge);
      return res;
    } catch (e) {
      log("error api call login", error: e);
      return false;
    }
  }
}
