import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/knowledge_base/knowledge_vm.dart';
import 'package:ez_xpert/screen/knowledge_base/webView.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/platform_interface.dart';

import '../../api/api_config.dart';

class Knowledge extends StatefulWidget {
  const Knowledge({Key? key}) : super(key: key);

  @override
  _KnowledgeState createState() => _KnowledgeState();
}

class _KnowledgeState extends State<Knowledge> {
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
    getKnowledge();
  }

  getKnowledge() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>"+token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://ez-xpert.ca/api/knowledge'));
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': user_id.toString()});
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        leaveList = result['data'];
        log(response.body);
      });
      print("user result-->" + result.toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          /*const Icon(
            Icons.person,
            color: Colors.black,
            size: 22,
          ),
          Center(
              child: Text(
            " ${user_name ?? "user"}   ",
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins400',
              fontSize: 16,
            ),
          ))*/
        ],
        title: Text(
          language!.dr_text4,
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            padding: const EdgeInsets.only(left: 10),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(50),
            //   border: Border.all(color: const Color(0xff1a226c), width: 2),
            // ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Expanded(
                  //   flex: 4,
                  //   child: Container(
                  //     margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  //     child: DropdownSearch<dynamic>(
                  //       dropdownSearchDecoration: InputDecoration(
                  //         contentPadding: const EdgeInsets.symmetric(
                  //             vertical: 0, horizontal: 10),
                  //         label: const Text("Tag"),
                  //         alignLabelWithHint: false,
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(15.0),
                  //         ),
                  //       ),
                  //       mode: Mode.MENU,
                  //       items: const ["Demo ", "Tool", "KT", "Others"],
                  //       itemAsString: (val) {
                  //         if (val.runtimeType == String) {
                  //           return val;
                  //         }
                  //         return val.name;
                  //       },
                  //       showClearButton: false,
                  //       onChanged: (val) {},
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            //label: Text("Key word"),
                            hintText: language!.dr_text7,
                            filled: true,
                            fillColor: const Color(0xffFAFAFA),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent,width: 0,style: BorderStyle.none),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent,width: 0,style: BorderStyle.none),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent,width: 0,style: BorderStyle.none),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))
                            ),
                            ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        getKnowledge();
                      },
                      child: Container(
                        width: 56,
                          decoration: const BoxDecoration(
                            color: Color(0xff1B2072),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15))
                          ),
                          child: const Icon(Icons.search,color: Colors.white,)))
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: leaveList.isEmpty ? 0 : leaveList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 14),
              itemBuilder: (context, i) {
                return InkWell(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.ondemand_video_outlined,
                          color: Color(0xffE1CF82),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4,),
                              Text(
                                leaveList[i]['title'],
                                style: const TextStyle(
                                    fontFamily: 'Poppins400',
                                    color: Color(0xff626262),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),
                              ),
                            /*  Text(
                                leaveList[i]['source_link'],
                                style: const TextStyle(
                                    fontFamily: 'Poppins400',
                                    color: Color(0xff626262),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14
                                ),
                              ),*/
                              Text(
                                leaveList[i]['date'],
                                style: const TextStyle(
                                    fontFamily: 'Poppins400',
                                    color: Color(0xffC4C4C4),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  WebViewScreen(leaveList[i]['source_link'].toString())));

                    //_launchURL(leaveList[i]['source_link']);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }



  Future<void> _launchURL(String url) async {
    final link = (url.toString().contains("http")) ? url : "$url";

    if (!await launch(
      link,
      forceSafariVC: true,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}

 /* void _launchURL(String url) async {
    final link = (url.toString().contains("http")) ? url : "$url";
    if (!await launch(link,forceSafariVC: true,
      forceWebView: false, )) throw 'Could not launch $link';
  }
}
*/