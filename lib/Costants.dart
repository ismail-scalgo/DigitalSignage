import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// String BASEURL = "https://web-dev-sgdsignage.scalgo.net";
String BASEURL = "http://192.168.0.98:8000";
List<String> mediaTypes = ["jpeg", "mp4"];
String PLATFORM = 'WEB';
String HARDCODEPLATFORM = 'WEB';
double gheight = 0;
double gwidth = 0;
String SOCKET_ADDRESS = 'ws://192.168.0.98:8765';

Future<bool> isOffline() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    return true;
  } else {
    return false;
  }
}
