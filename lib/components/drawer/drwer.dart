import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_xpert/api/api_config.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/knowledge_base/knowledge.dart';
import 'package:ez_xpert/screen/notice/notice.dart';
import 'package:ez_xpert/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../screen/auth/login/login_screen.dart';
import '../../screen/call_schedule/Event_Calendar/EventCalendar.dart';
import 'package:http/http.dart' as http;

import '../../screen/employee_warning/employee_warning.dart';
import '../../screen/home_main/home_page.dart';

class DrawerWidget extends StatefulWidget {
  final Function logOut;

  const DrawerWidget({Key? key, required this.logOut}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int? user_id;
  String? user_name, user_photo, user_email, token;
  var demo_photo =
      "https://www.shareicon.net/data/512x512/2016/05/24/770137_man_512x512.png?123";

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getInt("user_id");
      token = prefs.getString("tokenkey");
      getprofile();
      //  user_name = prefs.getString("user_name");
      // user_photo = "User/public/images/userphoto/"+prefs.getString("user_photo").toString();
    });
  }

  final textStyle = const TextStyle(
      fontFamily: 'Poppins400',
      fontWeight: FontWeight.w500,
      color: Color(0xff4B4B4B));

  getprofile() async {
    //EasyLoading.isShow;
    final prefs = await SharedPreferences.getInstance();
    print("token::::::=>" + token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          ApiConfig.baseUrl + ApiConfig.getProfile,
        ));
    request.headers.addAll(headers);
    request.fields.addAll({'id': user_id.toString()});
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        user_name = result['data']['name'];
        user_photo = result['data']['profile_photo_url'];
        user_email = result['data']['email'];
      });
      print("profile result-->" + result.toString());
    } else {
      // EasyLoading.dismiss();
      print(response.reasonPhrase);
    }
  }

  logout() async {
    //EasyLoading.isShow;
    final prefs = await SharedPreferences.getInstance();
    print("token::::::=>" + token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    EasyLoading.show();
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.logout));
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result['message']),
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        EasyLoading.dismiss();
      });
      print("profile result-->" + result.toString());
    } else {
      EasyLoading.dismiss();
      print(response.reasonPhrase);
    }
  }

  deleteAccount() async {
    //EasyLoading.isShow;
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    EasyLoading.show();
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.account_delete));
    request.headers.addAll(headers);
    request.fields.addAll({'id': user_id.toString()});
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        EasyLoading.dismiss();
      });
      print("profile result-->" + result.toString());
    } else {
      EasyLoading.dismiss();
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(locator<SharedPrefs>().user!.profilePic.toString() + "1234");
    // Color bg = HexColor("#ffe5a2");
    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.white,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 15),
              color: const Color(0xFFFFFFFF),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5, top: 36),
                    child: IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.clear, color: Color(0xFF848484)
                          //color: Colors.white,
                          ),
                      // the method which is called
                      // when button is pressed
                      onPressed: () {
                        setState(
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 36, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: user_photo.toString(),
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const SizedBox(),
                              placeholder: (_, __) => const SizedBox(),
                            ),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user_name ?? "Ez-xpert",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                //color: Colors.black,
                                color: Color(0xFF4B4B4B),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins400',
                                letterSpacing: 1,
                                height: 1.5,
                              ),
                            ),
                            Text(
                              user_email ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Color(0xFF4B4B4B),
                                // color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins400',
                                letterSpacing: 1,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                width: 120.00,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:
                                      const Color(0xff1b2072).withOpacity(.21),
                                ),
                                child: const Text(
                                  "Edit Profile",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF1B2072),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins400',
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            padding: const EdgeInsets.only(left: 24, top: 20),
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 30.00,
                    height: 30.00,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xFFDDDDDD),
                      image: const DecorationImage(
                        scale: 2.4,
                        image: ExactAssetImage('assets/call.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  title: Text(
                    language!.dr_text1,
                    style: textStyle,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventCalendar()));
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 30.00,
                    height: 30.00,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xFFDDDDDD),
                      // image: const DecorationImage(
                      //   scale: 2.2,
                      //   alignment: Alignment.center,
                      //   fit: BoxFit.scaleDown,
                      //   image: ExactAssetImage(
                      //       'assets/company_alert.png'),
                      // ),
                    ),
                    padding: const EdgeInsets.only(bottom: 4, right: 2),
                    child: Image.asset(
                      'assets/company_alert.png',
                      scale: 2.3,
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  title: Text(
                    language!.dr_text2, //'Company Alert'
                    style: textStyle,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Notice()));
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 30.00,
                    height: 30.00,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xFFDDDDDD),
                      image: const DecorationImage(
                        scale: 2.72,
                        image: ExactAssetImage('assets/knowlage.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  title: Text(language!.dr_text4, //'Knowledge Base'
                      style: textStyle),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Knowledge()));
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 30.00,
                    height: 30.00,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xFFDDDDDD),
                      image: const DecorationImage(
                        scale: 3.72,
                        image: ExactAssetImage('assets/warnning.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  title: Text(language!.dr_text12, //'Knowledge Base'
                      style: textStyle),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Employee_warning()));
                  },
                ),
                // ListTile(
                //   leading: Container(
                //     width: 30.00,
                //     height: 30.00,
                //     decoration: BoxDecoration(
                //       borderRadius:
                //       BorderRadius.circular(100.0),
                //       color:  const Color(0xFFDDDDDD),
                //       image: const DecorationImage(
                //         scale: 2.6,
                //         image: ExactAssetImage(
                //             'assets/language.png'),
                //         fit: BoxFit.scaleDown,
                //       ),
                //     ),
                //   ),
                //   title: Text('Language',style: textStyle,),
                // ),
                Theme(
                  data: ThemeData(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.only(right: 26),
                    title: ListTile(
                      leading: Container(
                        width: 30.00,
                        height: 30.00,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: const Color(0xFFDDDDDD),
                          image: const DecorationImage(
                            scale: 2.6,
                            image: ExactAssetImage('assets/language.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      title: Text(
                        'Language',
                        style: textStyle,
                      ),
                    ),
                    childrenPadding: EdgeInsets.zero,
                    // expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 55),
                        transform: Matrix4.translationValues(00, -30, 0),
                        child: LanguageListWidget(
                          widgetType: WidgetType.LIST,
                          scrollPhysics: const BouncingScrollPhysics(),
                          onLanguageChange: (v) {
                            appStore.setLanguage(v.languageCode!);
                            setState(() {});
                            finish(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePageMain()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 30.00,
                    height: 30.00,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xFFDDDDDD),
                      image: const DecorationImage(
                        scale: 38,
                        image: ExactAssetImage('assets/bin.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  title: Text(
                    language!.dr_text5, //'Account Delete'
                    style: textStyle,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        insetPadding:
                            const EdgeInsets.only(left: 15, right: 15),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        content: Container(
                          height: 280,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/delete_aco.png',
                                height: 75,
                                width: 75,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text(
                                "Delete account ?",
                                style: TextStyle(
                                  color: Color(0xFF000113),
                                  fontFamily: 'Poppins400',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "Are you sure you want to delete your",
                                style: TextStyle(
                                  color: Color(0xFF828282),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Text(
                                "account?",
                                style: TextStyle(
                                  color: Color(0xFF828282),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 50,
                                      color: const Color(0xFFE0E0E0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, '');
                                      },
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontFamily: 'Poppins400',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      minWidth: 55,
                                      height: 50,
                                      color: const Color(0xFFF45151),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () {
                                        deleteAccount();
                                      },
                                      child: const Text(
                                        "Delete account",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontFamily: 'Poppins400',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    /*showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Text(language!.dr_text9),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'No'),
                            child: Text(language!.dr_text11),
                          ),
                          TextButton(
                            onPressed: () => deleteAccount(),
                            child: Text(language!.dr_text10),
                          ),
                        ],
                      ),
                    );*/
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 30.00,
                    height: 30.00,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xFFDDDDDD),
                      image: const DecorationImage(
                        scale: 2.6,
                        image: ExactAssetImage('assets/Logout.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  title: Text(
                    language!.dr_text6, //'Logout'
                    style: textStyle,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        insetPadding:
                            const EdgeInsets.only(left: 15, right: 15),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        content: SizedBox(
                          height: 280,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/log_out.png',
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 33,
                              ),
                              const Text(
                                "Log out ?",
                                style: TextStyle(
                                  color: Color(0xFF000113),
                                  fontFamily: 'Poppins400',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                language!.dr_text8,
                                style: TextStyle(
                                  color: Color(0xFF828282),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Text(
                                "",
                                style: TextStyle(
                                  color: Color(0xFF828282),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 50,
                                      color: const Color(0xFFE0E0E0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, '');
                                      },
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontFamily: 'Poppins400',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      minWidth: 55,
                                      height: 50,
                                      color: const Color(0xfff1b2072),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.clear();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                        // logout();
                                      },
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontFamily: 'Poppins400',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    /*showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        insetPadding: EdgeInsets.only(left: 15,right: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(15.0))),
                        content: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/delete_aco.png',
                                height: 75,
                                width: 75,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 33,),
                              Text(
                                "Delete account ?",
                                style: TextStyle(
                                  color:  Color(0xFF000113),
                                  fontFamily: 'Poppins400',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              SizedBox(height: 33,),
                              Text(
                                "Are you sure you want to delete your",
                                style: TextStyle(
                                  color:  Color(0xFF828282),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "account?",
                                style: TextStyle(
                                  color:  Color(0xFF828282),
                                  fontFamily: 'Poppins400',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Expanded(child: MaterialButton(
                                    minWidth: double.infinity,
                                    height: 50,
                                    color: Color(0xFFE0E0E0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, '');
                                    },
                                    child: Text(
                                      "Close",
                                      style: TextStyle(
                                        color: Color(0xFF8F8F8F),
                                        fontFamily: 'Poppins400',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),),
                                  SizedBox(width: 6,),
                                  Expanded(child:  MaterialButton(
                                    minWidth: 55,
                                    height: 50,
                                    color: Color(0xFFF45151),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      deleteAccount();
                                    },
                                    child: Text(
                                      "Delete account",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontFamily: 'Poppins400',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),)

                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    );*/
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

/*  deleteAccount() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.account_delete));
    request.fields.addAll({'user_id': user_id.toString()});
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Account Delete"),
            content: Text(json['message']),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  //widget.logOut();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Account Delete"),
            content: Text(json['message']),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }*/

}
