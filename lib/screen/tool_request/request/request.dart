import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/components/dropdown/dropdown_menu_mode.dart';
import 'package:ez_xpert/components/input/input_field.dart';
import 'package:ez_xpert/model/tool_model.dart';
import 'package:ez_xpert/screen/tool_request/request/request_vm.dart';
import 'package:ez_xpert/utils/validators.dart';
import 'package:flutter/material.dart';

class ToolRequestPopup extends StatefulWidget {
  final List<ToolModel>? tools;
  const ToolRequestPopup({Key? key, this.tools}) : super(key: key);

  @override
  _LeaveRequestState createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<ToolRequestPopup>
    with BasePage<ToolRequestPopupVM> {
  @override
  Widget build(BuildContext context) {
    return builder(() => Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Form(
              key: provider!.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  const Text("Tool Request",
                    style: TextStyle(
                      color: Color(0xff202020),
                      fontFamily: 'Poppins400',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 10),
                  DropDownMenuMode(
                    hinttext: "Tool *",
                    items: provider!.tools ?? [],
                    setdata: provider!.selectTool,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      provider!.selectStartDate();
                    },
                    child: IgnorePointer(
                      child: ProfileInput(
                        controller: provider!.startDate,
                        sIcon: const Icon(Icons.calendar_today),
                        hintText: "Start Date *",
                        initialvalue: null,
                        validator: Validators.basic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      provider!.selectEndDate();
                    },
                    child: IgnorePointer(
                      child: ProfileInput(
                        controller: provider!.endDate,
                        sIcon: const Icon(Icons.calendar_today),
                        hintText: "End Date *",
                        initialvalue: null,
                        validator: Validators.basic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileInput(
                    onsaved: provider!.setReason,
                    hintText: "Reason*",
                    validator: Validators.basic,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      MaterialButton(
                        height: 40,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xff1B2072)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                            style: TextStyle(
                              color: Color(0xff1B2072),
                              fontFamily: 'Poppins400',
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                            ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      MaterialButton(
                        height: 40,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          provider!.saveRequest();
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  ToolRequestPopupVM create() => ToolRequestPopupVM();

  @override
  void initialise(BuildContext context) {
    provider!.tools = widget.tools;
  }
}
