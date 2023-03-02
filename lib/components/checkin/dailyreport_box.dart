import 'package:ez_xpert/main.dart';
import 'package:flutter/material.dart';

import '../../utils/formatter.dart';

class DailyReportWidget extends StatelessWidget {
  const DailyReportWidget({Key? key, required this.data}) : super(key: key);
  final Map data;


  @override
  Widget build(BuildContext context) {
  /*  var dailycheckin,dailycheckout;
    dailycheckin=CustomFormat.formatTime(DateTime.parse(data['work_in']));
    dailycheckout=CustomFormat.formatTime(DateTime.parse(data['work_out']));*/

    print("data-->"+data.toString());
    return Container(
      //height: 140,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xffFAFAFA)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [

                Row(children: [
                  Text(language!.inout_text10,style: const TextStyle(
                      color: Color(0xff202020),
                      fontFamily: 'Poppins400',
                      fontSize: 17.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,decoration: TextDecoration.none,),),
                  const SizedBox(width: 5,),
                  Text(data['date'],textAlign: TextAlign.center,style: const TextStyle(
                      color: Color(0xff202020),
                      fontFamily: 'Poppins400',
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,decoration: TextDecoration.none),),
                ],),
                const SizedBox(height: 6,),


                //Text(language!.inout_text10,style: TextStyle(fontSize: 12,color: Colors.black,decoration: TextDecoration.none),),
                Text(language!.inout_text11,style: const TextStyle(color: Color(0xff8B8B8B),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text(language!.inout_text12,style: const TextStyle(color: Color(0xff8B8B8B),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text(language!.inout_text13,style: const TextStyle(color: Color(0xff8B8B8B),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text(language!.inout_text14,style: const TextStyle(color: Color(0xff8B8B8B),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text(language!.inout_text15,style: const TextStyle(color: Color(0xff8B8B8B),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               // Text(data['date'],textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),),
                // Text(" "),
                const SizedBox(height: 30,),

                Text("${data['work_in'] ?? "00:00:00" } to ${data['work_out'] ?? "00:00:00" }",
                  maxLines: 1,
                  textAlign: TextAlign.right,style: const TextStyle(color: Color(0xff1B2072),
                        fontFamily: 'Poppins400',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                const SizedBox(height: 2,),

                Text("${data['regular_time']}",textAlign: TextAlign.center,style: const TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                const SizedBox(height: 2,),
                Text("${data['over_time']}",textAlign: TextAlign.center,style: const TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                const SizedBox(height: 2,),
                Text("${data['emrge_time']}",textAlign: TextAlign.center,style: const TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                const SizedBox(height: 2,),
                Text("${data['sold_hr'] ?? 0 }",textAlign: TextAlign.center,style: const TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
