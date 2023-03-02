import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/components/input/input_field.dart';
import 'package:ez_xpert/screen/profile/profile_vm.dart';
import 'package:ez_xpert/utils/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api/api_config.dart';
import '../../main.dart';
import '../../utils/formatter.dart';
import '../home_main/home_page.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Dio? _dio;
  int? user_id;
  List leaveList = [];
  var user_name, user_photo, user_dl, user_tl, user_sn;
  var demo_photo =
          "https://www.shareicon.net/data/512x512/2016/05/24/770137_man_512x512.png?123",
      demo_dl =
          "https://o.remove.bg/downloads/934ec805-05cd-4209-b67f-371a73a2dace/Screen-Shot-2016-12-17-at-9.00.28-PM2-removebg-preview.png",
      demo_tl =
          "https://o.remove.bg/downloads/d6aa2e91-0a70-40c3-8565-0889a618637e/logo-removebg-preview.png",
      demo_sn =
          "https://o.remove.bg/downloads/d6aa2e91-0a70-40c3-8565-0889a618637e/logo-removebg-preview.png";
  TextEditingController dob = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();

  File? profilePick;
  File? dLPick;
  File? tLPick;
  File? sInPick;
  final formKey = GlobalKey<FormState>();
  var loading = false;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    user_name = prefs.getString("user_name");
    getprofile();
  }

  getprofile() async {
    EasyLoading.isShow;
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.getProfile));
    request.headers.addAll(headers);
    request.fields.addAll({'id': user_id.toString()});
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (result == "true") {}
      setState(() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        name = TextEditingController(text: result['data']['name']);
        dob = TextEditingController(text: result['data']['dob']);
        // father=TextEditingController(text: result['result']['father']);
        email = TextEditingController(text: result['data']['email']);
        mobile =
            TextEditingController(text: result['data']['mobile'].toString());
        user_photo = result['data']['profile_photo_url'];
        user_dl = result['data']['driving_license_url'];
        user_tl = result['data']['trade_license_image'];
        user_sn = result['data']['sin_no_url'];
        setState(() {});
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Edit profile",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF000113),
              //color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              letterSpacing: 1.4,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Color(0xFF000113),
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomePageMain()));
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(width: double.infinity, height: 10),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    image: DecorationImage(
                                        image: profilePick == null
                                            ? NetworkImage(user_photo == null
                                                ? demo_photo
                                                : user_photo.toString())
                                            : FileImage(profilePick!)
                                                as ImageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              Positioned(
                                bottom: 10,
                                right: -5,
                                child: InkWell(
                                  onTap: () => pickProfile(),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xff1a226c),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 45),
                          ProfileInput(
                            onsaved: (val) {
                              //provider!.user?.name = val;
                            },
                            hintText: "${language!.pro_text1} *", //"Name *",
                            // initialvalue: provider!.user?.name ?? "jk",
                            controller: name,
                            validator: Validators.basic,
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              selectDob();
                            },
                            child: IgnorePointer(
                              child: ProfileInput(
                                onsaved: (val) {
                                  dob = TextEditingController(text: val);
                                },
                                controller: dob,
                                sIcon: const Icon(Icons.calendar_today),
                                hintText: "${language!.pro_text2} *",
                                //"Date of Birth *",
                                validator: Validators.basic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // ProfileInput(
                          //   onsaved: (val) {
                          //     provider!.user?.father = val;
                          //   },
                          //   hintText: "Father/Husband *",
                          //   controller: provider!.father,
                          //   validator: Validators.basic,
                          // ),
                          // const SizedBox(height: 10),
                          ProfileInput(
                            onsaved: (val) {
                              //provider!.user?.email = val;
                            },
                            inputType: TextInputType.emailAddress,
                            hintText: "${language!.pro_text3} *",
                            //"Email *",
                            controller: email,
                            readOnly: true,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 15),
                          ProfileInput(
                            onsaved: (val) {
                              //provider!.user?.mobile = val;
                            },
                            inputType: TextInputType.phone,
                            hintText: "${language!.pro_text4} *",
                            //"Mobile *",
                            controller: mobile,
                            validator: Validators.mobile,
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: pickDl,
                                    child: Column(
                                      children: [
                                        Text(
                                          "${language!.pro_text5} *",
                                          //"Driving Licence",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Container(
                                          height: 100,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: dLPick == null
                                                    ? NetworkImage(
                                                        user_dl == null
                                                            ? demo_dl
                                                            : user_dl)
                                                    : FileImage(dLPick!)
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            //border: Border.all(color: const Color(0xff1a226c),width: 2),
                                            color: Colors.grey,
                                          ),
                                          // child: Text("data"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    onTap: pickTl,
                                    child: Column(
                                      children: [
                                        Text(
                                          "${language!.pro_text6} *",
                                          //"Trade Licence",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                          height: 15,
                                        ),
                                        Container(
                                          height: 100,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: tLPick == null
                                                  ? NetworkImage(user_tl == null
                                                      ? demo_tl
                                                      : user_tl)
                                                  : FileImage(tLPick!)
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // const SizedBox(width: 10),
                                // Expanded(
                                //   child: InkWell(
                                //     onTap: pickSin,
                                //     child: Column(
                                //       children: [
                                //         const Text(
                                //           "SIN No.",
                                //           style: TextStyle(
                                //             fontSize: 14,
                                //             color: Colors.black,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //         ),
                                //         const SizedBox(width: 5),
                                //         Container(
                                //           height: 100,
                                //           width: double.infinity,
                                //           decoration: BoxDecoration(
                                //             image: DecorationImage(
                                //                 image: sInPick == null
                                //                     ? NetworkImage(
                                //                         user_sn==null?demo_sn:user_sn)
                                //                     : FileImage(sInPick!)
                                //                         as ImageProvider,
                                //                 fit: BoxFit.contain),
                                //             borderRadius:
                                //                 BorderRadius.circular(10),
                                //             color: Colors.grey,
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 50,
                              color: Color(0xff1B2072),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              onPressed: () {
                                //provider!.updaet();
                                // updaet();
                                update();
                              },
                              child: Text(
                                "${language!.pro_text7}", //'Update',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: double.infinity, height: 10),
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
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePageMain()));
        return false;
      },
    );
    // ),
    //   ),
    // );
  }

  void update() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      var request = await http.MultipartRequest(
          "POST", Uri.parse(ApiConfig.baseUrl + ApiConfig.updateProfile));
      request.headers.addAll(headers);
      request.fields.addAll({
        'name': name.text.toString(),
        'dob': dob.text.toString(),
        'mobile': mobile.text.toString(),
      });
      if (user_photo == null) {
        print("ph up");
        request.files.add(
            await http.MultipartFile.fromPath('profile', profilePick!.path));
      }
      if (user_dl == null) {
        print("dl up");
        request.files.add(
            await http.MultipartFile.fromPath('driving_license', dLPick!.path));
      }
      if (user_tl == null) {
        print("tl up");
        request.files.add(
            await http.MultipartFile.fromPath('trade_license', tLPick!.path));
      }
      if (user_sn == null) {
        print("sn up");
        request.files
            .add(await http.MultipartFile.fromPath('sin_no', sInPick!.path));
      }

      print("===>" + request.files.toString());

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var dataAll = json.decode(response.body);
      if (response.statusCode == 200) {
        if (dataAll['success'] == true) {
          EasyLoading.dismiss();
          EasyLoading.showToast(dataAll['message'].toString(),
              toastPosition: EasyLoadingToastPosition.bottom);
          setState(() {});
        } else {
          EasyLoading.dismiss();
          EasyLoading.showToast(dataAll['message'].toString());
        }

        // getprofile();
      } else {
        print("error-->" + response.body);
        await EasyLoading.dismiss();
        //showError(Messages.unknownError);
      }
    }
  }

  void pickProfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null) {
        if (result.files.single.size < 5000000) {
          user_photo = null;
          profilePick = File(result.files.single.path!);
        } else {
          showAlertDialog(context);
        }
      } else {}
    });
  }

  void pickDl() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null) {
        if (result.files.single.size < 5000000) {
          user_dl = null;
          dLPick = File(result.files.single.path!);
        } else {
          showAlertDialog(context);
        }
      } else {}
    });
  }

  void pickTl() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null) {
        if (result.files.single.size < 5000000) {
          user_tl = null;
          tLPick = File(result.files.single.path!);
        } else {
          showAlertDialog(context);
        }
      } else {}
    });
  }

  void pickSin() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null) {
        if (result.files.single.size < 5000000) {
          user_sn = null;
          sInPick = File(result.files.single.path!);
        } else {
          showAlertDialog(context);
        }
      } else {}
    });
  }

  void selectDob() async {
    DateTime? date = await showDatePicker(
      context: MyApp.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    dob.text = CustomFormat.formatDate(date);
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Image Picker"),
          content: const Text("File size is greater than 5MB"),
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
}
