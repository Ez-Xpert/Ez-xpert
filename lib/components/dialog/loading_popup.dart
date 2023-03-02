// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPopup {
  static const router = 'loading_popup';
  static show(BuildContext context) {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: LoadingPopup.router),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SpinKitDoubleBounce(
            color: Colors.white,
            size: 50.0,
          ),
        );
      },
    );
  }
}
