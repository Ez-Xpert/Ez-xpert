import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../api/api_config.dart';
import '../../components/common/poppins_common_text.dart';

class Employee_warning extends StatefulWidget {
  const Employee_warning({Key? key}) : super(key: key);

  @override
  _Employee_warningState createState() => _Employee_warningState();
}

class _Employee_warningState extends State<Employee_warning> {
  late bool status=true;
  int? user_id;
  List leaveList = [];
  List Reasons = [];
  String? user_name;
  var familyMemberse;
  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    user_name = prefs.getString("user_name");
    getEmployee_warning();
  }

  getEmployee_warning() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>"+token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://ez-xpert.ca/api/employee-warning'));
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': user_id.toString()});
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      status=result['success'];
      if(result['success']==true)
        {
          setState(() {
            leaveList = result['data'];
           // Reasons=result['data']['reasons_for_warning'];
            //Reasons=result['data']['reasons_for_warning'];
             //familyMembers = result["data"][0]["reasons_for_warning"].toString();
            Reasons = result["data"][0]["reasons_for_warning"];



            log(response.body);
          });
        }

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
        ],
        title: Text(
          language!.dr_text12,
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
          status==false?Container(
            child: Align(
              alignment: Alignment.center,
              child:Text("No Warning Available",style: const TextStyle(
                  fontFamily: 'Poppins400',
                  color: Color(0xff626262),
                  fontWeight: FontWeight.w600,
                  fontSize: 14
              ),) ,),
          ):
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
                      color: const Color(0xffefebeb),
                      borderRadius: BorderRadius.circular(15)
                    ),
                      child:SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PoppinsAddText(
                              textAlign: TextAlign.start,
                              text: language!.employee_warning1+" "+leaveList[i]['id'].toString(),
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 50,
                              child: TextField(
                                enableInteractiveSelection: false, // will disable paste operation
                                enabled: false,
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                obscureText: false,

                                decoration: InputDecoration(
                                  hintText: leaveList[i]['heading'],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            
                            PoppinsAddText(
                              textAlign: TextAlign.start,
                              text: language!.employee_warning2,
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 50,
                              child: TextField(
                                enableInteractiveSelection: false, // will disable paste operation
                                enabled: false,
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                obscureText: false,

                                decoration: InputDecoration(
                                  hintText: leaveList[i]['meeting_date'],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            PoppinsAddText(
                              textAlign: TextAlign.start,
                              text: language!.employee_warning3,
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListView.builder(
                                itemCount: leaveList[i]['reasons_for_warning'].isEmpty ? 0 : leaveList[i]['reasons_for_warning'].length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 1,left: 5),
                                itemBuilder: (context, j) {
                                  return InkWell(
                                    child: Container(

                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffefebeb),
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        child:SingleChildScrollView(
                                          child: Container(
                                            color: const Color(0xffefebeb),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  color: const Color(0xffefebeb),
                                                  child: PoppinsAddText(
                                                    textAlign: TextAlign.start,
                                                    text: leaveList[i]['reasons_for_warning'][j],
                                                    fontSize: 16,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                    onTap: () async {

                                    },
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),
                            PoppinsAddText(
                              textAlign: TextAlign.start,
                              text: language!.employee_warning4,
                              fontSize: 16,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 50,
                              child: TextField(
                                enableInteractiveSelection: false, // will disable paste operation
                                enabled: false,
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                                obscureText: false,

                                decoration: InputDecoration(
                                  hintText: leaveList[i]["corrective_measures"].toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ),



                          ],
                        ),
                      ),
                    )
                   /* child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [


                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4,),
                              Column(children: [
                                Text(
                                  leaveList[i]['heading'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),

                              ],),
                              Row(children: [
                                Text(
                                  language!.employee_warning2,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  leaveList[i]['meeting_date'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Color(0xff626262),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                  ),
                                ),
                              ],),
                              Row(children: [
                                Text(
                                  language!.employee_warning3,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  leaveList[i]['reasons'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Color(0xff626262),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                  ),
                                ),
                              ],),
                              Row(children: [
                                Text(
                                  "other_reasons",
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  leaveList[i]['other_reasons'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Color(0xff626262),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                  ),
                                ),
                              ],),
                              Row(children: [
                                Text(
                                  "warning",
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  leaveList[i]['warning'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Color(0xff626262),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                  ),
                                ),
                              ],),
                              Row(children: [
                                Text(
                                  "termination",
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  leaveList[i]['termination'],
                                  style: const TextStyle(
                                      fontFamily: 'Poppins400',
                                      color: Color(0xff626262),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                  ),
                                ),
                              ],),
                            ],
                          ),
                        ),
                      ],
                    ),*/
                  ),
                  onTap: () async {

                  },
                );
              },
            ),
          ),
          Container(
            child: new Divider(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }


}
