import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:ez_xpert/screen/tool_request/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../api/api_config.dart';
import '../../components/input/input_field.dart';
import '../../main.dart';
import '../../utils/formatter.dart';
import '../../utils/validators.dart';

class ToolRequest extends StatefulWidget {
  const ToolRequest({Key? key}) : super(key: key);

  @override
  _ToolRequestState createState() => _ToolRequestState();
}

class _ToolRequestState extends State<ToolRequest> {
  int? user_id;
  int? paid = 0, sick = 0, casual = 0, other = 0;
  List leaveList = [];
  List toolList = [];
  bool valid = true;
  String toolId = '';

  String? emp_id;
  String? role_id;
  var reason;

  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController resoanCon = TextEditingController();

  String? selectedTool;

  void setReason(var newvalue) {
    print("resaon-->" + newvalue!);
    reason = newvalue;
    setState(() {
      reason = newvalue;
    });
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

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("user_id");
    //print("userid"+user_id.toString());
    //getuser();
    // getTools();
    fetchTool();
    getToolRequestList();
  }

  getToolRequestList() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());

    try {
      EasyLoading.show();
      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.tool_request_list),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString("token")}'
        },
      );
      var dataAll = json.decode(response.body);
      log(response.body);
      if (dataAll['success'] == true) {
        leaveList = dataAll['data'];
        EasyLoading.dismiss();
        setState(() {});
      } else {
        EasyLoading.dismiss();
        EasyLoading.showToast(dataAll['message'].toString());
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e.toString());
    }
  }

  add_Tools() async {
    print("--->" +
        startDate.text.toString() +
        endDate.text +
        "reeee--->" +
        reason.toString());
    if (formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      print("token::::::=>" + token.toString());
      var body = json.encode({
        'tool_id': toolId,
        'from_date': startDate.text,
        'to_date': endDate.text,
        'reason': resoanCon.text,
      });
      print(body);
      try {
        EasyLoading.show();
        var response = await http.post(
            Uri.parse(ApiConfig.baseUrl + ApiConfig.requestTool),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${prefs.getString("token")}'
            },
            body: body);
        var dataAll = json.decode(response.body);
        log(response.body);
        if (dataAll['success'] == true) {
          getToolRequestList();
          EasyLoading.dismiss();
          Navigator.pop(context);
          EasyLoading.showToast(dataAll['message'].toString());
          setState(() {});
        } else {
          EasyLoading.dismiss();
          EasyLoading.showToast(dataAll['message'].toString());
        }
      } catch (e) {
        EasyLoading.dismiss();
        print(e.toString());
      }
    }
  }

  fetchTool() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());

    try {
      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.gettools),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString("token")}'
        },
      );
      var dataAll = json.decode(response.body);
      log(response.body);
      if (dataAll['success'] == true) {
        toolList = dataAll['data'];
        setState(() {});
      } else {
        EasyLoading.showToast(dataAll['message'].toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    getUserId();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MaterialButton(
        height: 50,
        color: HexColor("#1a226c"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () async {
          var data = await showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 28),
              child: ToolRequestPopup(context),
            ),
          );
          if (data == true) {
            //provider!.getTools();
            // getTools();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              language!.tool_text1, //"Tool Request",
              style: const TextStyle(
                color: Color(0xffffffff),
                fontFamily: 'Poppins400',
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: leaveList.isEmpty
          ? const Center(
              child: Text(
              'No tool reqeust available',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ))
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                getToolRequestList();
              },
              child: ListView.builder(
                  itemCount: leaveList.isEmpty ? 0 : leaveList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8)
                      .copyWith(top: 14),
                  itemBuilder: (context, i) {
                    return RequestCard(
                      data: leaveList[i],
                    );
                  }),
              color: Colors.white,
              backgroundColor: const Color(0xff1a226c),
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
            ),
    );
  }

  Widget ToolRequestPopup(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 6,
            ),
            Text(
              language!.tool_text1, //"Tool Request",
              style: const TextStyle(
                color: Color(0xff202020),
                fontFamily: 'Poppins400',
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 26),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              height: valid ? 50 : 60,
              child: Theme(
                data: ThemeData(
                  primaryColor: const Color(0xff1B2072),
                  primarySwatch: Colors.deepPurple,
                ),
                child: DropdownSearch<dynamic>(
                  showSearchBox: true,
                  validator: (v) {
                    if (v == null) {
                      setState(() {
                        valid = false;
                      });
                      return "required field";
                    } else {
                      setState(() {
                        valid = true;
                      });
                      return null;
                    }
                  },
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    label: Text(language!.tool_text2),
                    alignLabelWithHint: false,
                    fillColor: const Color(0xffFAFAFA),
                    hintStyle:
                        const TextStyle(color: Colors.black, fontSize: 14),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  mode: Mode.BOTTOM_SHEET,
                  items: toolList.map((e) => e['name']).toList(),
                  itemAsString: (val) {
                    if (val.runtimeType == String) {
                      return val;
                    }
                    return val.name;
                  },
                  showClearButton: false,
                  onChanged: (val) {
                    // widget.setdata(val);
                    selectedTool = val;
                    for (int i = 0; i < toolList.length; i++) {
                      if (selectedTool == toolList[i]['name']) {
                        toolId = toolList[i]['id'].toString();
                        print(toolId);
                      }
                    }
                  },
                  selectedItem: selectedTool,
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                selectStartDate();
              },
              child: IgnorePointer(
                child: ProfileInput(
                  controller: startDate,
                  sIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                  hintText: "${language!.tool_text3} *", //"Start Date *",
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
                    color: Colors.black,
                    size: 20,
                  ),
                  hintText: "${language!.tool_text4} *", //"End Date *",
                  initialvalue: null,
                  validator: Validators.basic,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ProfileInput(
              onsaved: setReason,
              hintText: "${language!.tool_text5} *", //"Reason*",
              controller: resoanCon,
              validator: Validators.basic,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xff1B2072),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          language!.leave_text11, //'Close',
                          style: const TextStyle(
                            color: Color(0xff1B2072),
                            fontFamily: 'Poppins400',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        add_Tools();
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xff1B2072),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          language!.leave_text12, //'Save',
                          style: const TextStyle(
                            color: Color(0xffFFFFFF),
                            fontFamily: 'Poppins400',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
