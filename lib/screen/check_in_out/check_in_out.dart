import 'dart:convert';
import 'dart:io';

import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/components/checkin/report_box.dart';
import 'package:ez_xpert/screen/check_in_out/check_in_out_vm.dart';
import 'package:ez_xpert/screen/check_in_out/sell_hours/sell_hours.dart';
import 'package:ez_xpert/screen/profile/profile.dart';
import 'package:ez_xpert/utils/formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:hexcolor/hexcolor.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_config.dart';
import '../../components/checkin/dailyreport_box.dart';
import '../../main.dart';
import '../../utils/locator.dart';
import '../../utils/share_prefs.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class CheckInOut extends StatefulWidget {
  const CheckInOut({Key? key}) : super(key: key);

  @override
  _CheckInOutState createState() => _CheckInOutState();
}

class _CheckInOutState extends State<CheckInOut> with BasePage<CheckInOutVM> {
  var canada;

  DateTime? checkinTime;
  String? dailycheckin;
  DateTime? checkOutTime;
  String? dailycheckout;
  bool emer = true;

/*  void _getPSTTime() {
    tz.initializeTimeZones();

    //final DateTime now = DateTime.now();
    DateTime now = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(provider!.dailycheckin.toString());
    final pacificTimeZone = tz.getLocation('America/New_York');
    var cc = tz.TZDateTime.from(now, pacificTimeZone);
    String formattedDate = DateFormat('kk:mm:ss').format(cc);
    print("===>" + formattedDate.toString());
    setState(() {
      provider!.dailycheckin = formattedDate;
    });
  }*/

  int? user_id;
  List leaveList = [];
  String? user_name;
  @override
  void initState() {
    setState(() {
      //_getPSTTime();
      getUserId();
    });
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getInt("user_id");
      user_name = prefs.getString("user_name");
      //getuser();
    });
  }

  getuser() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.getHours));
    request.fields.addAll({'user_id': user_id.toString()});
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        leaveList = result['result']['news'];
      });
      print("user result-->" + result.toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {

    return builder(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (_, __) {
                print("check...${provider!.dailycheckin}");
                print("chhh...${provider!.dailycheckout}");
                print(provider!.emer);
                tz.initializeTimeZones();
                var detroit = tz.getLocation('America/Detroit');
                var now = tz.TZDateTime.now(detroit).day;
                print('now..$now');
                if(provider!.currentDay.isNotEmpty){
                  if(double.parse(now.toString())>double.parse('${provider?.currentDay.toString().split('-')[2]}')){
                    provider?.onChangedCheckInOut();
                  }
                }
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 26,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    provider!.dailycheckout.isEmpty
                                        ? MainAxisAlignment.center
                                        : MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        provider!.dailycheckin.isEmpty
                                            ? ''
                                            : provider!.dailycheckin.toString(),
                                        //canada,
                                        // CustomFormat.formatTime(provider!.dailycheckin),
                                        style: const TextStyle(
                                          color: Color(0xff000113),
                                          fontFamily: 'Poppins400',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        provider!.dailycheckin.isNotEmpty
                                            ? language!.inout_text19
                                            : '',
                                        style: const TextStyle(
                                          color: Color(0xffC4C4C4),
                                          fontFamily: 'Poppins400',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/forward.png',
                                    height: 32,
                                    width: 25,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  provider!.dailycheckout.isNotEmpty &&
                                          provider!.dailycheckin.isNotEmpty
                                      ? const SizedBox(
                                          height: 10,
                                        )
                                      : const SizedBox(height: 0),
                                  Column(
                                    children: [
                                      Text(
                                        provider!.dailycheckout.isNotEmpty
                                            ? provider!.dailycheckout.toString()
                                            : '',
                                        style: const TextStyle(
                                          color: Color(0xff000113),
                                          fontFamily: 'Poppins400',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        provider!.dailycheckout.isNotEmpty
                                            ? language!.inout_text20
                                            : '',
                                        style: const TextStyle(
                                          color: Color(0xffC4C4C4),
                                          fontFamily: 'Poppins400',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 28,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    provider!.dailycheckout.isEmpty ||
                                            provider!.dailycheckin.isEmpty
                                        ?
                                    MaterialButton(
                                            onPressed: () {
                                              provider!
                                                  .checkinOrCheckout(user_id);
                                            },
                                            height: 45,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .05),
                                            shape: const StadiumBorder(),
                                            color: HexColor("#1a226c"),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  provider!.dailycheckin.isEmpty
                                                      ? Icons.play_arrow_rounded
                                                      : Icons.stop_rounded,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                    " Check ${provider!.dailycheckin.isEmpty ? "In" : "Out"}",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'Poppins400',
                                                        color: Colors.white))
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    provider!.dailycheckout.isEmpty ||
                                            provider!.dailycheckin.isEmpty
                                        ? const SizedBox(
                                            width: 12,
                                          )
                                        : const SizedBox(
                                            height: 0,
                                          ),
                                    MaterialButton(
                                      height: 45,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .05),
                                      shape: const StadiumBorder(),
                                      onPressed: () {
                                        print("emr-->" +
                                            provider!.emer.toString());
                                        provider!.emerCheckinOut(user_id);
                                      },
                                      color: HexColor("#1a226c"),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            provider!.checkEmerStart
                                                ? Icons.stop_rounded
                                                : Icons.play_arrow_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            provider!.checkEmerStart
                                                ? language!
                                                    .inout_text18 //"Emergency Stop"
                                                : language!
                                                    .inout_text1, //"Emergency Start",
                                            style: const TextStyle(
                                                fontFamily: 'Poppins400',
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (provider!.dailycheckout.isNotEmpty)
                                      const SizedBox(
                                        width: 12,
                                      ),
                                    provider!.dailycheckout.isNotEmpty
                                        ? MaterialButton(
                                            height: 45,
                                            elevation: 0,
                                            color: const Color(0xff1B2072)
                                                .withOpacity(.21),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .05),
                                            shape: const StadiumBorder(),
                                            onPressed: () async {
                                              var res = await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) =>
                                                        const AlertDialog(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  insetPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: SellHours(),
                                                ),
                                              );
                                              if (res == true) {
                                                provider!.getLeave();
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  language!
                                                      .inout_text7, //"Sold Hours ",
                                                  style: const TextStyle(
                                                    color: Color(0xff1B2072),
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins400',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   child: _tabSection(context),
                        // ),
                        Theme(
                          data: ThemeData(
                            tabBarTheme: const TabBarTheme(
                              labelColor: Color(0xff1a226c),
                              labelStyle:
                                  TextStyle(fontSize: 18), // color for text
                              indicator: UnderlineTabIndicator(
                                // color for indicator (underline)
                                borderSide: BorderSide(
                                    color: Color(0xff1a226c), width: 3),
                              ),
                            ), // deprecated,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Material(
                              elevation: 0,
                              color: Colors.white,
                              //color: Color(0xffffe5a2),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      // text: "${language!.inout_text8}",
                                      child: Text(
                                        language!.inout_text8,
                                        style: const TextStyle(
                                          color: Color(0xff1B2072),
                                          fontFamily: 'Poppins400',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      //"Daily Report",
                                    ),
                                    Tab(
                                      //text: "${language!.inout_text9}",
                                      child: Text(
                                        language!.inout_text9,
                                        style: const TextStyle(
                                          color: Color(0xff1B2072),
                                          fontFamily: 'Poppins400',
                                          fontSize: 16.0,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ), //"Emergency Report",
                                    ),
                                  ], //labelColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ];
              },
              body: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TabBarView(children: [
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider!.dailyreport.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 6)
                          .copyWith(top: 12),
                      itemBuilder: (context, i) {
                        return DailyReportWidget(
                            data: provider!.dailyreport[i]);
                      }),
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider!.emergencyWork.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 6)
                          .copyWith(top: 12),
                      itemBuilder: (context, i) {
                        return ReportWidget(data: provider!.emergencyWork[i]);
                      }),
                ]),
              )),
        ),
      ),
    );
  }

  // Widget _tabSection(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       tabBarTheme: const TabBarTheme(
  //         labelColor: Color(0xff1a226c),
  //         labelStyle: TextStyle(fontSize: 18), // color for text
  //         indicator: UnderlineTabIndicator(
  //           // color for indicator (underline)
  //           borderSide: BorderSide(color: Color(0xff1a226c), width: 3),
  //         ),
  //       ), // deprecated,
  //     ),
  //     home: DefaultTabController(
  //       length: 2,
  //       child: Column(
  //         //mainAxisSize: MainAxisSize.max,
  //         //crossAxisAlignment: CrossAxisAlignment.start,
  //         //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Expanded(
  //             child:
  //                 TabBarView(physics: const BouncingScrollPhysics(), children: [
  //               ListView.builder(
  //                   physics: const BouncingScrollPhysics(),
  //                   itemCount: provider!.dailyreport.length,
  //                   shrinkWrap: true,
  //                   itemBuilder: (context, i) {
  //                     return DailyReportWidget(data: provider!.dailyreport[i]);
  //                   }),
  //               ListView.builder(
  //                   physics: const BouncingScrollPhysics(),
  //                   itemCount: provider!.emergencyWork.length,
  //                   shrinkWrap: true,
  //                   itemBuilder: (context, i) {
  //                     return ReportWidget(data: provider!.emergencyWork[i]);
  //                   }),
  //             ]),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  CheckInOutVM create() => CheckInOutVM();

  @override
  void initialise(BuildContext context) {}
}
