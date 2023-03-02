import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/screen/time_sheet/payroll_card.dart';
import 'package:ez_xpert/screen/time_sheet/time_sheet_vm.dart';
import 'package:flutter/material.dart';

class TimeSheet extends StatefulWidget {
  const TimeSheet({Key? key}) : super(key: key);

  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> with BasePage<TimeSheetVM> {
  @override
  Widget build(BuildContext context) {
    return builder(
      () => Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     const Icon(Icons.person),
        //     Center(child: Text("  ${provider!.prefs.user?.name ?? "user"}  "))
        //   ],
        //   title: const Text("Time Sheet"),
        // ),
        body:

        Column(
          children: [
            Row(
              children: [
                Text('Start Date'),
                
              ],
            ),

            ListView.builder(
              itemCount: provider!.payroll.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          boxShadow: [
                            BoxShadow(color: Colors.grey[400]!, blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SALARY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                            ),
                            const SizedBox(height: 2),
                            payElement("Basic Pay", provider!.basePay),
                            const SizedBox(height: 2),
                            payElement("Incentive", provider!.incentive),
                            const SizedBox(height: 2),
                            payElement("Tax", provider!.tax),
                            const SizedBox(height: 2),
                            payElement("Deduction", provider!.deduction),
                            // const Divider(),
                            const SizedBox(height: 2),
                            payElement("Total Netpay", provider!.total),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                        child: const Text(
                          "PAYROLL REPORT",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  );
                }

                return Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(i.toString()),
                    Expanded(
                        child: PayRollCard(
                      payroll: provider!.payroll[i - 1],
                    )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget payElement(String? name, amount) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Text(
              name ?? "",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )),
        const Text(":",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        const SizedBox(width: 10),
        Expanded(
          flex: 6,
          child: Text(
            amount ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  TimeSheetVM create() => TimeSheetVM();

  @override
  void initialise(BuildContext context) {}
}
