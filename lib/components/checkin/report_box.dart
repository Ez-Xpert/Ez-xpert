import 'package:flutter/material.dart';

import '../../main.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({Key? key, required this.data}) : super(key: key);
  final Map data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xffFAFAFA)
      ),
      /*decoration: BoxDecoration(
        color: const Color(0xffffe5a2),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: const Color(0xff1a226c),width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            offset: Offset(0, 0),
          )
        ],
      ),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                Text(language!.inout_text10+"  :",style: const TextStyle(color: Color(0xff8B8B8B),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text(language!.inout_text16+"  :",style: const TextStyle(color: Color(0xff8B8B8B),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text(language!.inout_text17+"  :",style: const TextStyle(color: Color(0xff8B8B8B),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(data['date'],style: const TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text("${data['from_time']} to ${data['to_time']}",style: const TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text("${data['emergency_time'] ?? 0}",style: const TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
              ],
            ),
          ),
          /*Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Text(language!.inout_text17,style: TextStyle(color: Color(0xff8B8B8B),
                     fontFamily: 'Poppins400',
                     fontSize: 15.0,
                     fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
                Text("${data['diff_hr'] ?? 0}",style: TextStyle(color: Color(0xff1B2072),
                    fontFamily: 'Poppins400',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,decoration: TextDecoration.none)),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
