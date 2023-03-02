import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ez_xpert/api/api_config.dart';
import 'package:ez_xpert/screen/time_sheet_response.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Registration_WebView.dart';
import '../main.dart';

class NewTimeSheet extends StatefulWidget {
  const NewTimeSheet({Key? key}) : super(key: key);

  @override
  _NewTimeSheetState createState() {
    return _NewTimeSheetState();
  }
}

class _NewTimeSheetState extends State<NewTimeSheet> {
  String date = "";
  String overtimeHours = "";
  String regularHours = "";
  String emergencyHours = "";
  String efficiency = "";
  String efficiency_text = "";
  DateTime startselectedDate = DateTime.now();
  DateTime endselectedDate = DateTime.now();
  int? user_id;
  List timeSheetList = [];
  String fileurl = "https://ez-xpert.ca/api/attendance-pdf";
  String invoiceFull = 'https://ez-xpert.ca/api/attendance-pdf';
  @override
  initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getInt("user_id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectStartDate(context);
                          },
                          child: Container(
                            width: 140,
                            child: TextFormField(
                              enabled: false,
                              cursorColor: Colors.black,
                              cursorHeight: 18,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1.4)),
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                  ),
                                  contentPadding: const EdgeInsets.all(5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: language!.time_text1,
                                  labelText:
                                      "${startselectedDate.day}-${startselectedDate.month}-${startselectedDate.year}"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectEndDate(context);
                          },
                          child: Container(
                            width: 140,
                            child: TextFormField(
                              enabled: false,
                              cursorColor: Colors.black,
                              cursorHeight: 18,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black45, width: 1.4)),
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                  ),
                                  contentPadding: const EdgeInsets.all(5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: language!.time_text1,
                                  labelText:
                                      "${endselectedDate.day}-${endselectedDate.month}-${endselectedDate.year}"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 1,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.only(left: 10, right: 17),
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF1B2072)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                  child: Text(language!.time_text3),
                  onPressed: () {
                    getData();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                  getData();
                },
                child: ListView.builder(
                    itemCount: timeSheetList.isEmpty ? 0 : timeSheetList.length,
                    itemBuilder: (context, i) {
                      print("===>" + timeSheetList[i].toString());
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Color(0xffFAFAFA),
                        elevation: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    language!.time_text4 + '  ',
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontFamily: 'Poppins400',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  timeSheetList[i]['regular_time'] == null
                                      ? Text("0",
                                          style: const TextStyle(
                                            color: Color(0xff1B2072),
                                            fontFamily: 'Poppins400',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ))
                                      : Text(
                                          timeSheetList[i]['regular_time']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Color(0xff1B2072),
                                            fontFamily: 'Poppins400',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    language!.time_text5,
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontFamily: 'Poppins400',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    timeSheetList[i]['over_time'].toString(),
                                    style: const TextStyle(
                                      color: Color(0xff1B2072),
                                      fontFamily: 'Poppins400',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    language!.time_text6,
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontFamily: 'Poppins400',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    timeSheetList[i]['emergency_time'].toString(),
                                    style: const TextStyle(
                                      color: Color(0xff1B2072),
                                      fontFamily: 'Poppins400',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    language!.time_text7,
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontFamily: 'Poppins400',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    timeSheetList[i]['efficiency_status'].toString(),
                                    style: const TextStyle(
                                      color: Color(0xff1B2072),
                                      fontFamily: 'Poppins400',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    language!.time_text8,
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontFamily: 'Poppins400',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    timeSheetList[i]['efficiency'].toString(),
                                    style: const TextStyle(
                                      color: Color(0xff1B2072),
                                      fontFamily: 'Poppins400',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    language!.time_text9,
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontFamily: 'Poppins400',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "\$" + timeSheetList[i]['bonus'].toString(),
                                    style: const TextStyle(
                                      color: Color(0xff1B2072),
                                      fontFamily: 'Poppins400',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                color: Colors.white,
                backgroundColor: Color(0xff1a226c),
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void webViewScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Registration_webview(invoiceFull.toString())));
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var start = startselectedDate.toString().split(" ")[0];
    var end = endselectedDate.toString().split(" ")[0];
    print("start-->" + start + "end-->" + end.toString());

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.getHours));
    request.fields
        .addAll({'start_date': start.toString(), 'end_date': end.toString()});
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("--->" + response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      //var res = TimeSheetResponse.fromJson(result);
      var dataAll = json.decode(response.body);
      setState(() {
        timeSheetList = dataAll['data'];
        timeSheetList = dataAll['data'];
        // overtimeHours = result["data"]["over_time"].toString();
        /*   regularHours = result['data']['regular_time'].toString();
        emergencyHours = result['data']['emergency_time'].toString();
        efficiency = result['data']['efficiency_status'].toString();
        efficiency_text = result['data']['efficiency'].toString();*/
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  _selectStartDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: startselectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != startselectedDate) {
      setState(() {
        startselectedDate = selected;
      });
    }
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: endselectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != endselectedDate) {
      setState(() {
        endselectedDate = selected;
      });
    }
  }

  void setData(Result result) {}

/*
  Future<TimeSheetResponse> fetchProducts() async {
    */ /* final queryParameters = {
                  'emp_id': '82',
                  'start_date': '2022-05-17',
                  'end_date': '2022-06-27',
                };
               // final uri = Uri.http('User/api/getHoursByDateAndId?emp_id=82&start_date=2022-05-17&end_date=2022-06-27');
                final response =  http.get(Uri.parse('https://ez-xpert.ca/User/api/getHoursByDateAndId?emp_id=82&start_date=2022-05-17&end_date=2022-06-27'));
                print(response);*/ /*




  }*/
}
