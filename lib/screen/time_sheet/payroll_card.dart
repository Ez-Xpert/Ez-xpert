import 'package:flutter/material.dart';

class PayRollCard extends StatelessWidget {
  const PayRollCard({Key? key, required this.payroll}) : super(key: key);
  final Map payroll;
  // final String date =
  //     "${CustomFormat.formatDate(DateTime.now())}  to  ${CustomFormat.formatDate(DateTime.now())}";
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(5, 5, 10, 5),
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey[400]!, blurRadius: 2)],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date : ${payroll['period_frm']}  to  ${payroll['period_to']}",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                        flex: 7,
                        child: Text(
                          "Basic Pay",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )),
                    const Text(
                      ": ",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Text(
                          "${payroll['pay']}",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "Tax(-)",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )),
                    const Text(
                      ": ",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "${payroll['tax']}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                        flex: 7,
                        child: Text(
                          "Incentive",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )),
                    const Text(
                      ": ",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Text(
                          "${payroll['incentive']}",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        )),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                        flex: 6,
                        child: Text(
                          "Deduction(-)",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )),
                    const Text(": "),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "${payroll['ded']}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      flex: 7,
                      child: Text(
                        "OverTime",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(": "),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${payroll['overtime'] ?? ""}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      flex: 7,
                      child: Text(
                        "EMG Time",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(": "),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${payroll['emgtime'] ?? ""}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                        flex: 7,
                        child: Text(
                          "Total Time",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )),
                    const Text(
                      ": ",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${payroll['totaltime'] ?? ""}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "Netpay : ${payroll['net'] ?? ""}",
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
          ),
          Text(
            "Paid on ${payroll['dop'] ?? ""}",
            style: const TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
