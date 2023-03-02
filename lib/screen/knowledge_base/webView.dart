import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/main.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../api/api_config.dart';

class WebViewScreen extends StatefulWidget {

  var url = '';
  WebViewScreen(this.url,);

  @override
  _WebViewScreenState createState() => _WebViewScreenState(url);
}

class _WebViewScreenState extends State<WebViewScreen> {

  _WebViewScreenState(this.url);
  var url = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [],
        title: Text(
          language!.dr_text4,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins400',
          ),
        ),
        elevation: .4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body:  WebView(
        initialUrl: url.toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
