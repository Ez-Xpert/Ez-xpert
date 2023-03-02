import 'package:dio/dio.dart';
import 'package:ez_xpert/screen/new_time_sheet.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path;

class Registration_webview extends StatefulWidget {
  var registrationProf = '';
  Registration_webview(this.registrationProf);

  @override
  State<Registration_webview> createState() =>
      _Registration_webviewState(registrationProf);
}

class _Registration_webviewState extends State<Registration_webview> {
  _Registration_webviewState(this.registrationProf);

  var registrationProf = '';

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Color(0xffFFF9EC)),
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/Icon_back.png',
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        previousScreen();
                      },
                    ),
                    Text(
                      'Invoice',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0,
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  /*_launchWhatsapp();*/
                  downloadBook(
                      downloadLink:
                          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                      title: "test");
                },
                child: Container(
                    height: 75,
                    width: 75,
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Icon(
                      Icons.arrow_circle_down_rounded,
                      color: Colors.black,
                    )),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: WebView(
          initialUrl: registrationProf,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewTimeSheet()));
  }

  /* _launchWhatsapp() async {
    if (await canLaunch(
        registrationProf)) {
      await launch(
          registrationProf,);
    } else {
      throw 'Could not launch $widget.registrationProf';
    }
  }*/

  _launchWhatsapp() async {
    if (await canLaunch(registrationProf)) {
      await launch(registrationProf);
    } else {
      throw 'Could not launch $widget.registrationProf';
    }
  }

  downloadBook({String? downloadLink, String? title}) async {
    var dio;
    if (await Permission.storage.request().isGranted) {
      final downloadPath = await path.getExternalStorageDirectory();
      var filePath = downloadPath!.path + '/$title.pdf';

      dio = Dio();
      await dio.download(downloadLink, filePath).then((value) {
        dio.close();
      }).catchError((Object e) {
        Fluttertoast.showToast(
            msg: "Terjadi kesalahan. Download gagal.", timeInSecForIosWeb: 1);
      });
    } else {}
  }
}
