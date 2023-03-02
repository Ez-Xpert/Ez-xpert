// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ez_xpert/api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/dropdown/dropdown_menu_mode.dart';
import '../../components/input/input_field.dart';
import '../../main.dart';
import '../../utils/formatter.dart';
import '../../utils/validators.dart';

class Vacation extends StatefulWidget {
  const Vacation({Key? key}) : super(key: key);

  @override
  _VacationState createState() => _VacationState();
}

class _VacationState extends State<Vacation> {
  int? user_id;
  int personal = 0, vacation = 0, unpaid = 0;
  List leaveList = [];
  var emp_id;
  var role_id;
  var leave_type_id;
  var leave_type, reason, token;

  @override
  void initState() {
    setState(() {
      getUserId();
    });
    getUserId();
    super.initState();
  }

  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();

  void setType(String? newType) {
    leave_type = newType;
  }

  void setReason(String? newReason) {
    reason = newReason;
  }

  void selectStartDate() async {
    DateTime? date = await showDatePicker(
      context: MyApp.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    startDate.text = CustomFormat.formatDate(date);
  }

  void selectEndDate() async {
    DateTime? date = await showDatePicker(
      context: MyApp.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    endDate.text = CustomFormat.formatDate(date);
  }

  final formKey = GlobalKey<FormState>();

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    //print("userid"+user_id.toString());
    // getuser();
    getAllLeave();
  }

  getAllLeave() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());
    try {
      EasyLoading.show();
      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.getLeave),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var dataAll = json.decode(response.body);
      log(response.body);
      if (dataAll['success'] == true) {
        vacation = dataAll['data']['totalVacationLeave'];
        personal = dataAll['data']['totalPersonalLeave'];
        unpaid = dataAll['data']['totalUnpaidLeave'];
        leaveList =
            dataAll['data']['data'] != '' ? dataAll['data']['data'] : [];
        EasyLoading.dismiss();
        setState(() {});
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
    }
  }

  add_leave() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());
    EasyLoading.show();
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    print("--->" + role_id.toString());
    if (formKey.currentState!.validate()) {
      var request = http.MultipartRequest(
          'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.addLeave));
      request.headers.addAll(headers);
      if (leave_type == "Personal leave") {
        leave_type_id = 1;
      } else if (leave_type == "Vacation leave") {
        leave_type_id = 2;
      } else if (leave_type == "Unpaid leave") {
        leave_type_id = 3;
      }
      request.fields.addAll({
        'start_date': startDate.text,
        'end_date': endDate.text,
        'leave_type': leave_type_id.toString(),
        'reason': reason.toString(),
      });
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);
      var dataAll = json.decode(response.body);
      if (response.statusCode == 200) {
        if (dataAll['success'] == true) {
          EasyLoading.showToast(dataAll['message'].toString());
          EasyLoading.dismiss();
          getAllLeave();
          setState(() {
            getAllLeave();
          });
          Navigator.pop(MyApp.context, true);
        } else {
          EasyLoading.showToast(dataAll['message'].toString());
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.showToast(dataAll['message'].toString());
        EasyLoading.dismiss();
        Navigator.pop(MyApp.context, false);
        print(response.body);
      }
    }
  }

  @override
  void didChangeDependencies() {
    getAllLeave();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MaterialButton(
        // minWidth: double.infinity,
        height: 50,
        color: HexColor("#1a226c"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () async {
          var res = await showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 36),
              child: LeaveRequest(context),
            ),
          );
          if (res == true) {
            //provider!.getLeave();
            getAllLeave();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              language!.leave_text6,
              style: TextStyle(
                color: Color(0xffffffff),
                fontFamily: 'Poppins400',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            SizedBox(
              height: 14,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xff1a226c),
              elevation: 1,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${language!.leave_text2}",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins400',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, top: 1, bottom: 1),
                              decoration: BoxDecoration(
                                  color: Color(0xffFAE690),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text("${personal}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins400',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Day",
                                style: const TextStyle(
                                  color: Color(0xffFAE690),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            language!.leave_text1,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins400',
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, top: 1, bottom: 1),
                              decoration: BoxDecoration(
                                  color: Color(0xffFAE690),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text("${vacation}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins400',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Day",
                                style: const TextStyle(
                                  color: Color(0xffFAE690),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${language!.leave_text3}",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins400',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, top: 1, bottom: 1),
                              decoration: BoxDecoration(
                                  color: Color(0xffFAE690),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text("${unpaid}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins400',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Day",
                                style: const TextStyle(
                                  color: Color(0xffFAE690),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                  getAllLeave();
                },
                child: ListView.builder(
                    itemCount: leaveList.isEmpty ? 0 : leaveList.length,
                    itemBuilder: (context, i) {
                      print("===>" + leaveList[i].toString());
                      return Container(
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400]!,
                              blurRadius: 1,
                              offset: const Offset(0, 0),
                            )
                          ],
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Text(
                                  leaveList[i]['leave_type'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins400',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.only(right: 10, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        language!.leave_text5,
                                        //"Total Days",
                                        style: TextStyle(
                                            color: Color(0xff949090),
                                            fontSize: 14,
                                            fontFamily: 'Poppins400',
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        leaveList[i]["totalDay"].toString(),
                                        style: TextStyle(
                                            color: Color(0xff949090),
                                            fontSize: 15,
                                            fontFamily: 'Poppins400',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 19,
                                  color: Color(0xff949090),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  leaveList[i]['start_date'] +
                                      " TO " +
                                      leaveList[i]['end_date'],
                                  style: const TextStyle(
                                      color: Color(0xff949090),
                                      height: 1.5,
                                      fontSize: 15,
                                      fontFamily: 'Poppins400',
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 2),
                              decoration: BoxDecoration(
                                  color: leaveList[i]['status'] == 0
                                      ? Colors.orange
                                      : leaveList[i]['status'] == 1
                                          ? Colors.green
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                leaveList[i]['status'] == 0
                                    ? language!.tool_text7 //"Pending"
                                    : leaveList[i]['status'] == 1
                                        ? language!.tool_text6 //"Approved"
                                        : language!.tool_text8,
                                //"Rejected",
                                style: const TextStyle(
                                    fontFamily: 'Poppins400',
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                          ],
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

  Widget LeaveRequest(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width - 55,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 6,
                ),
                Text(
                  "${language!.leave_text6}", //"Leave Request",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins400',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    selectStartDate();
                  },
                  child: IgnorePointer(
                    child: ProfileInput(
                      controller: startDate,
                      sIcon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                      hintText: "${language!.leave_text7} *",
                      //"Start Date *",
                      initialvalue: null,
                      validator: Validators.basic,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    selectEndDate();
                  },
                  child: IgnorePointer(
                    child: ProfileInput(
                      controller: endDate,
                      sIcon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                      hintText: "${language!.leave_text8} *",
                      //"End Date *",
                      initialvalue: null,
                      validator: Validators.basic,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropDownMenuMode(
                  hinttext: "${language!.leave_text9} *", //"Leave type *",
                  items: const [
                    "Vacation leave",
                    "Personal leave",
                    "Unpaid leave"
                  ],
                  setdata: setType,
                ),
                const SizedBox(height: 10),
                ProfileInput(
                  onsaved: setReason,
                  hintText: "${language!.leave_text10} *", //"Reason*",
                  validator: Validators.basic,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          height: 40,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            "${language!.leave_text11}", //'Close',
                            style: TextStyle(
                              color: Color(0xff1a226c),
                              fontFamily: 'Poppins400',
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: MaterialButton(
                          height: 40,
                          color: Color(0xff1B2072),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          onPressed: () {
                            add_leave();
                          },
                          child: Text(
                            "${language!.leave_text12}", //'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins400',
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ));
  }

  @override
  void initialise(BuildContext context) {}
}
