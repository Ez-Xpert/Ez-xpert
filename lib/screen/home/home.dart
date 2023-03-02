import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ez_xpert/base/base_page.dart';

//import 'package:ez_xpert/components/home/bar_chart.dart';
import 'package:ez_xpert/components/home/home_page_card.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/check_in_out/check_in_out.dart';
import 'package:ez_xpert/screen/home/home_vm.dart';
import 'package:ez_xpert/screen/time_sheet/time_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../../api/api_config.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.function}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final function;

  @override
  _HomeState createState() => _HomeState();
}

//class _HomeState extends State<Home> with BasePage<HomeVM> {
class _HomeState extends State<Home> {
  int? user_id;
  List leaveList = [];
  String? user_name;
  var no_of_days,
      no_of_hrs,
      no_of_days_miss,
      no_of_hrs_miss,
      Current_Month,
      current_year;

  var service_daily_goal_technicien,
      service_daily_goal_technicien_apprentice,
      install_daily_goal_technicien,
      install_daily_goal_technicien_apprentice;

  @override
  void initState() {
    setState(() {
      getUserId();
      callUpdate();
      getpackage();
    });
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getInt("user_id");
      user_name = prefs.getString("user_name");
      var now = DateTime.now();
      DateTime date = DateTime(now.year);
      var formatter = DateFormat('yyyy');
      String formattedDate = formatter.format(date);
      current_year = formattedDate.toString();
      print(formattedDate);
      getuser();
    });
  }

  getuser() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.getDash));
    request.fields.addAll({'user_id': user_id.toString()});
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("user result-->" + response.body.toString());
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        no_of_days = result['data']['work_day'];
        no_of_hrs = result['data']['hours_day'];
        no_of_days_miss = result['data']['miss_work_day'];
        no_of_hrs_miss = result['data']['miss_work_hours'];
        Current_Month = result['data']['current_date'];

        service_daily_goal_technicien =
            result['data']['service_daily_goal_technicien'];
        service_daily_goal_technicien_apprentice =
            result['data']['service_daily_goal_technicien_apprentice'];
        install_daily_goal_technicien =
            result['data']['install_daily_goal_technicien'];
        install_daily_goal_technicien_apprentice =
            result['data']['install_daily_goal_technicien_apprentice'];
      });
      print("user result-->" + result.toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  String appVersion = '';
  String androidVersion = '';
  String iosVersion = '';
  getpackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.buildNumber;
    print("appversion...$appVersion");
  }

  callUpdate() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.checkVersion),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${prefs.getString("token").toString()}',
        },
      );
      print(response.request);
      log("callupdate...${response.body}");
      var dataAll = json.decode(response.body);
      if (response.statusCode == 200) {
        androidVersion = dataAll['data']['android_version'].toString();
        iosVersion = dataAll['data']['ios_version'].toString();
        // androidVersion='1';
        // iosVersion='1';
        Platform.isAndroid ? androidUpdateContdion() : iosUpdateCondition();
      } else {
        // Get.back();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  androidUpdateContdion() {
    if (double.parse(appVersion) < double.parse(androidVersion)) {
      _onForceUpdate();
    }
  }

  iosUpdateCondition() {
    if (double.parse(appVersion) < double.parse(iosVersion)) {
      _onForceUpdate();
    }
  }

  _onForceUpdate() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0x00ffffff),
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: AlertDialog(
            title: const Text(
              'Update',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontStyle: FontStyle.normal,
                fontSize: 17.0,
              ),
            ),
            content: const Text(
              'A new update is available\nClick here to update your app.',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    LaunchReview.launch(
                        androidAppId: "com.ezxpert.ez_xpert1",
                        iOSAppId: 'com.ezxpert.ez-xpert1');
                  },
                  child: const Text(
                    "Update Now",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // provider.data!.forEach((key, value) {
    //   print(value.toString());
    // });
    int width = MediaQuery.of(context).size.width.toInt();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: <Widget>[
              Container(
                height: 180,
                width: (MediaQuery.of(context).size.width),
                color: HexColor("#ffffff"),
                child: Image.asset(
                  "assets/logo.jpeg",
                  fit: BoxFit.contain,
                  height: 180,
                ),
              ), //Container
              Container(
                padding: const EdgeInsets.all(1),
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: const Color(0xff1B216F),
                      elevation: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 10, left: 15),
                              child: Text(language!.home_text1,
                                  //"DAILY BENCHMARK FOR SERVICE AND INSTALL",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins400',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 20, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: const Color(0xffFFFFFF),
                                elevation: 1,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(language!.home_text2,
                                                          //'SERVICE Daily goal',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                      Text(
                                                        language!.home_text22,
                                                        //' (1 Electrician )',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xffF8A8A8)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                      service_daily_goal_technicien !=
                                                              null
                                                          ? "\$" +
                                                              service_daily_goal_technicien
                                                                  .toString()
                                                          : "0",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff1B2072),
                                                        fontFamily:
                                                            'Poppins400',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(language!.home_text3,
                                                          //'SERVICE Daily goal',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                      Text(
                                                        language!.home_text33,
                                                        //' (1 Electrician )',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xffF8A8A8)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                      service_daily_goal_technicien_apprentice !=
                                                              null
                                                          ? "\$" +
                                                              service_daily_goal_technicien_apprentice
                                                                  .toString()
                                                          : "0",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff1B2072),
                                                        fontFamily:
                                                            'Poppins400',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(language!.home_text4,
                                                          //'INSTALL Daily goal',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                      Text(
                                                        language!.home_text44,
                                                        //' (1 Electrician )',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xffF8A8A8)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Text(
                                                      install_daily_goal_technicien !=
                                                              null
                                                          ? "\$" +
                                                              install_daily_goal_technicien
                                                                  .toString()
                                                          : "0",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff1B2072),
                                                        fontFamily:
                                                            'Poppins400',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(language!.home_text5,
                                                          //'INSTALL Daily goal',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                      Text(
                                                        language!.home_text55,
                                                        //' (1 Electrician )',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins400',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Color(
                                                                0xffF8A8A8)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                      install_daily_goal_technicien_apprentice !=
                                                              null
                                                          ? "\$" +
                                                              install_daily_goal_technicien_apprentice
                                                                  .toString()
                                                          : "0",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff1B2072),
                                                        fontFamily:
                                                            'Poppins400',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: const Color(0xff1B216F),
                      elevation: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 10, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    language!.home_text6,
                                    //"POTENTIAL OPPORTUNITY WITH ELECTRIKA",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins400',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Current_Month == null
                                        ? "Current Month"
                                        : '${Current_Month}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins400',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 20, left: 5, right: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: const Color(0xffFFFFFF),
                                elevation: 1,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    language!.home_text7,
                                                    //'Number of Days Worked',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins400',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  no_of_days != null
                                                      ? no_of_days.toString()
                                                      : "0",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xff1B2072),
                                                    fontFamily: 'Poppins400',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    language!.home_text8,
                                                    //'Number of Hours Worked',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins400',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  no_of_hrs != null
                                                      ? no_of_hrs.toString()
                                                      : "0",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xff1B2072),
                                                    fontFamily: 'Poppins400',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    language!.home_text9,
                                                    //'Number of potential work days missed',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins400',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  no_of_days_miss != null
                                                      ? no_of_days_miss
                                                          .toString()
                                                      : "0",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xff1B2072),
                                                    fontFamily: 'Poppins400',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    language!.home_text10,
                                                    //'Number of potential work hours missed',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins400',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  no_of_hrs_miss != null
                                                      ? no_of_hrs_miss
                                                          .toString()
                                                      : "0",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xff1B2072),
                                                    fontFamily: 'Poppins400',
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ), //Container
              //Container
            ], //<Widget>[]
          ),
        ),
      ),
    );
  }

  @override
  HomeVM create() => HomeVM();

  @override
  void initialise(BuildContext context) {}
}
