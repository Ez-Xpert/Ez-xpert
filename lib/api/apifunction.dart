import 'dart:convert';
import 'dart:developer';

import 'package:ez_xpert/api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiFunction {
  callCategoriesCourses(
      BuildContext context, String authToken, String token) async {
    try {
      var body = json.encode({'device_token': token});
      print(authToken);
      var response =
          await http.post(Uri.parse(ApiConfig.baseUrl + ApiConfig.updateToken),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $authToken'
              },
              body: body);
      print(response.request);
      log(response.body);
      if (response.statusCode == 200) {
      } else {
        // Get.back();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
