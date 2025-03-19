import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// String BASEURL = "https://studio.zignflix.com";
// String BASEURL = "https://web-test-sgdsignage.scalgo.net";
//  String BASEURL = "http://192.168.0.98:8000";
 String BASEURL = "http://192.168.0.113:8000";
  String BASEURLMEDIA = "";
List<String> mediaTypes = ["jpeg", "mp4"];
String PLATFORM = 'WEB';
String HARDCODEPLATFORM = 'ANDROIDTV';
double gheight = 0;
double gwidth = 0;
// String SOCKET_ADDRESS = 'ws://studio.zignflix.com/ws/';

// String SOCKET_ADDRESS = 'ws://192.168.0.98:8765';
String SOCKET_ADDRESS = 'ws://192.168.0.113:8765';
// String SOCKET_ADDRESS = 'ws://192.168.0.84:8765';

Future<bool> isOffline() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none) ||
      connectivityResult.contains(ConnectivityResult.bluetooth) ||
      connectivityResult.contains(ConnectivityResult.vpn)) {
    return true;
  } else {
    return false;
  }
}

int TOTALPLAYERNO = 0;
