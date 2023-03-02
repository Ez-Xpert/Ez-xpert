import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'package:html/dom.dart' as dom;

class RequestCard extends StatelessWidget {
  const RequestCard({Key? key, this.data}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 8),
      padding: const EdgeInsets.fromLTRB(20, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 1,
            offset: const Offset(0, 0),
          )
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Text(
                "${data['tool']['name']}",
                style: const TextStyle(
                  color: Color(0xff202020),
                  fontFamily: 'Poppins400',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          buildDes(data['tool']['description'] ?? "Not available", 3),
          /* Text(
            data['tool']['description'] ?? "Not available",
            maxLines: 3,
            style: const TextStyle(
              color: Color(0xff8B8B8B),
              fontFamily: 'Poppins400',
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),*/
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        "${data['from_date']} To ${data['to_date']}",
                        style: const TextStyle(
                          color: Color(0xff202020),
                          fontFamily: 'Poppins400',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (data['status'] == 0 ||
                  data['status'] == 1 ||
                  data['status'] == 2 ||
                  data['status'] == 3 ||
                  data['status'] == 4)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: data['status'] == 0
                        ? Colors.orange
                        : data['status'] == 1
                            ? Colors.green
                            : data['status'] == 2
                                ? Colors.red
                                : data['status'] == 3
                                    ? Colors.blueAccent
                                    : data['status'] == 4
                                        ? Colors.yellow
                                        : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['status'] == 0
                        ? language!.tool_text7 //"REQUESTED"
                        : data['status'] == 1
                            ? language!.tool_text11 //"APPROVED"
                            : data['status'] == 2
                                ? language!.tool_text8 //"REJECTED"
                                : data['status'] == 3
                                    ? language!.tool_text9
                                    : data['status'] == 4
                                        ? language!.tool_text10
                                        : '', //"NOT RETURNED":'',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins400',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDes(String des, int maxlines) {
    return Html(
        data: des,
        style: {
          "body": Style(
            color: Color(0xff8B8B8B),
            fontFamily: 'Poppins400',
            fontSize: FontSize(14),
            fontWeight: FontWeight.w500,
            maxLines: maxlines,
          ),
        },
        onLinkTap: (url, __, _, ___) async {
          print("Opening $url...");

          if (await canLaunch(url!)) {
            await launch(url);
          } else {
            throw "Link cannot be handled";
          }
        },
        customRender: {
          "table": (context, child) {
            return (context.tree as TableLayoutElement).toWidget(context);
          }
        },
        onAnchorTap: (String? url, RenderContext context,
            Map<String, String> attributes, dom.Element? element) async {
          if (await canLaunch(url!)) {
            await launch(url);
          } else {
            throw "Link cannot be handled";
          }
          print("tap1");
        });
  }
}
