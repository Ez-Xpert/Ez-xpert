import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/main.dart';
import 'package:ez_xpert/screen/check_in_out/sell_hours/sell_hours_vm.dart';
import 'package:flutter/material.dart';

class SellHours extends StatefulWidget {
  const SellHours({Key? key}) : super(key: key);

  @override
  _SellHoursState createState() => _SellHoursState();
}

class _SellHoursState extends State<SellHours> with BasePage<SellHoursVm> {
  @override
  Widget build(BuildContext context) {
    return builder(() => Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Form(
              key: provider!.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    Text(language!.inout_text7,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    // ProfileInput(
                    //   onsaved:  provider!.setHours,
                    //   hintText: "Sell Hours *",
                    //   validator: Validators.basic,
                    // ),
                    TextField(
                        keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                          hintText: "Enter in Hours",
                          labelText: language!.inout_text7,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          provider!.setHours(text);
                          // provider!.geteffeciencydata();
                        }),
                    const SizedBox(height: 10),
                     Text(
                      language!.inout_text3+" :",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 1,
                              color: Colors.white,
                            ),
                          ],
                          // color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Column(
                        children: [
                          Text(
                            " ${provider!.totalworkingHours}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      height: 30,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        provider!.geteffeciencydata();
                      },
                      child:  Text(
                        language!.inout_text4,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: provider!.effeciecy != null,
                      child: Column(
                        children: [
                          const Text(
                            "Effeciency :",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.white,
                                  ),
                                ],
                                // color: Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Column(
                              children: [
                                Text(
                                  " ${provider!.effeciecy}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: provider!.isEffecient != null,
                      child: Column(
                        children: [
                          const Text(
                            "Is Effecient :",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.white,
                                  ),
                                ],
                                // color: Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Column(
                              children: [
                                Text(
                                  " ${provider!.isEffecient}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                          child: Text(
                            language!.inout_text5,
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
                            provider!.addSellHour();
                          },
                          child:Text(
                              language!.inout_text6,
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
          ),
        ));
  }

  @override
  SellHoursVm create() => SellHoursVm();

  @override
  void initialise(BuildContext context) {}
}
