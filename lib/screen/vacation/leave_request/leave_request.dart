import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/components/dropdown/dropdown_menu_mode.dart';
import 'package:ez_xpert/components/input/input_field.dart';
import 'package:ez_xpert/screen/vacation/leave_request/leave_request_vm.dart';
import 'package:ez_xpert/utils/validators.dart';
import 'package:flutter/material.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({Key? key}) : super(key: key);
  @override
  _LeaveRequestState createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest>
    with BasePage<LeaveRequestVm> {
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
              const Text("Leave Request",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400)),
              const Divider(thickness: 1, color: Colors.grey),
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
              DropDownMenuMode(
                hinttext: "Leave type *",
                items: const ["Paid leave", "Sick leave", "Casual leave", "Other leave"],
                setdata: provider!.setType,
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
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
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
  LeaveRequestVm create() => LeaveRequestVm();

  @override
  void initialise(BuildContext context) {}
}
