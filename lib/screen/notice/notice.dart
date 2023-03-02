import 'dart:convert';
import 'dart:io';

import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/notice/notice_vm.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_config.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  int? user_id;
  List leaveList = [];
  String? user_name;
  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    user_name = prefs.getString("user_name");
    getNotice();
  }

  getNotice() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://ez-xpert.ca/api/notice'));
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        if (result['data']['data'] != null) {
          leaveList = result['data']['data'];
        }
      });
      print("user result-->" + result.toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          /* const Icon(Icons.person,color: Colors.black,size: 22,),
            Center(child: Text(" ${user_name ?? "user"}   ",style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins400',
              fontSize: 16,
            ),))*/
        ],
        title: Text(
          language!.dr_text3,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins400',
          ),
        ),
        elevation: .4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.black,
          ),
        ),
        // actions: [
        // const Icon(Icons.person),
        // Center(child: Text("${user_name}"))
        // ],
        // title:  Text(language!.dr_text3),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: leaveList.isEmpty ? 0 : leaveList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 14),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          Color defineColor = const Color(0xff1a226c);
          Color textColor = Colors.white;
          var type;
          if (leaveList[i]["type"] == "1") {
            type = "Announcement";
            defineColor = const Color(0xff1a226c);
            textColor = Colors.white;
          }
          if (leaveList[i]["type"] == "2") {
            type = "Urgent Notice";
            textColor = Colors.purple;
            defineColor = Colors.purple.withOpacity(.22);
          }
          if (leaveList[i]["type"] == "3") {
            type = "Reminder";
            textColor = Color(0xff59DA56);
            defineColor = Color(0xff59DA56).withOpacity(.22);
          }
          if (leaveList[i]["type"] == "4") {
            type = "Warning";
            textColor = Color(0xffF45151);
            defineColor = Color(0xffF45151).withOpacity(.22);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: 14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            leaveList[i]["title"],
                            style: const TextStyle(
                              color: Color(0xff202020),
                              fontFamily: 'Poppins400',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: const Icon(
                        //     Icons.close,
                        //     color: Color(0xff1a226c),
                        //     size: 16,
                        //   ),
                        // ),
                        const SizedBox(width: 5)
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      leaveList[i]["content"],
                      style: const TextStyle(
                        color: Color(0xff8B8B8B),
                        fontSize: 14,
                        fontFamily: 'Poppins400',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Color(0xff202020),
                              ),
                              Text(
                                " " + leaveList[i]['created_at'],
                                style: const TextStyle(
                                  height: 1.56,
                                  color: Color(0xff1a226c),
                                  fontFamily: 'Poppins400',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                          decoration: BoxDecoration(
                              color: defineColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            type,
                            style: TextStyle(
                              color: textColor,
                              fontFamily: 'Poppins400',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
