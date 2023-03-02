import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/components/drawer/drwer.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/home_main/home_page_vm.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:launch_review/launch_review.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../api/api_config.dart';

class HomePageMain extends StatefulWidget {
  const HomePageMain({Key? key}) : super(key: key);

  @override
  _HomePageMainState createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain>
    with BasePage<HomePageMainVM> {
  Color bt = /*HexColor("#1a226c")*/ Colors.white;

  //int _currentIndex = 0;
  int _currentIndex = 0;

  // late String _title;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();
    updateFcmToken();
    // _title = 'Some default value';
  }

  updateFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('fcmToken');
    var map = Map<String, dynamic>();
    map['device_token'] = prefs.getString('fcmToken').toString();
    try {
      var response = await http.post(
          Uri.parse(ApiConfig.baseUrl + ApiConfig.updateToken),
          body: map,
          headers: {
            // HttpHeaders.contentTypeHeader: 'application/json',
            // HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${prefs.getString("token").toString()}',
          });
      print(response.request);
      print("map...$map");
      log(response.body);
      var dataAll = json.decode(response.body);
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return builder(
      () => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(provider!.title,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins400',
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              )),
          centerTitle: true,
          // automaticallyImplyLeading: false,
          //title: new Center(child: new Text(provider!.title, textAlign: TextAlign.center)),
          leading: IconButton(
            icon: Image.asset(
              "assets/drawer.png",
              height: 25,
              width: 25,
            ),
            onPressed: () => scaffoldKey.currentState!.openDrawer(),
          ),
        ),
        drawer: DrawerWidget(logOut: provider!.logOut),
        body: provider!.buildHome(),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              primaryColor: HexColor("#ffe5a2"),
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: HexColor("#ffe5a2")))),
          child: BottomNavigationBar(
            //backgroundColor: bt,
            //onTap: onTabTapped,
            //currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFF1C2270),
            unselectedItemColor: const Color(0xFF4563DB),
            elevation: 20,
            selectedLabelStyle: const TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
              fontSize: 12.0,
              letterSpacing: 1,
              fontWeight: FontWeight.w900,
              height: 1.6,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/home.png",
                  height: 25,
                  width: 25,
                ),
                //backgroundColor: Colors.lime,
                label: 'Home',
              ),
              BottomNavigationBarItem(
                //backgroundColor: Colors.blue,
                icon: Image.asset(
                  "assets/timesheet.png",
                  height: 25,
                  width: 25,
                ),
                // Icon(Icons.access_time),
                // Icon(
                //   Icons.calendar_today_outlined,
                //   // icon:Image.asset("assets/timesheet.png"),
                // ),
                label: 'Time Sheet',
              ),
              // BottomNavigationBarItem(
              //   backgroundColor: Colors.blue,
              //   icon:
              //   // Image.asset("assets/oncallschedule.png"),
              //   Icon(Icons.call),
              //   label: 'On Call',
              // ),
              BottomNavigationBarItem(
                //backgroundColor: Colors.blue,
                icon: Image.asset(
                  "assets/checkIn_Out.png",
                  height: 25,
                  width: 25,
                ),
                //Icon(Icons.punch_clock),
                label: language!.bn_text3,
              ),
              BottomNavigationBarItem(
                //backgroundColor: Colors.blue,
                icon: Image.asset(
                  "assets/vacation.png",
                  height: 25,
                  width: 25,
                ),
                //Icon(Icons.flight),
                label: 'Vacation',
              ),
              BottomNavigationBarItem(
                //backgroundColor: Colors.blue,
                icon: Image.asset(
                  "assets/tool.png",
                  height: 25,
                  width: 25,
                ),
                //Icon(Icons.build),
                label: 'Tool Request',
              )
            ],
            onTap: provider!.changeIndex,
            currentIndex: provider!.curentIndex,
          ),
        ),
      ),
    );
  }

  /* void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Jobs';
            Home(function: changeIndex);
          }
          break;
        case 1:
          {
            _title = 'Jobs';
            NewTimeSheet();
          }
          break;
        case 2:
          {
            _title = 'Timer';
            CheckInOut();
          }
          break;
        case 3:
          {
            _title = 'Overview';
            Vacation();
          }
          break;
        case 4:

            _title = 'Clients';
            return ToolRequest();

          break;
        default:
          {
            _title = 'Clients';
            Home();
          }
      }
    });
  }
  void changeIndex(val) {
    _currentIndex = val;
    _title = 'Some default value';
    //notifyListeners();
  }*/
  @override
  HomePageMainVM create() => HomePageMainVM();

  @override
  void initialise(BuildContext context) {}
}
