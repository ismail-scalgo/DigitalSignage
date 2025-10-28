import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

String BASEURL = "https://test-api.zignflix.com";
// String BASEURL = "https://api.zignflix.com/";

// String BASEURL = "https://dev-api.zignflix.com";

// String BASEURL = "http://192.168.0.67:8000";

// String SOCKET_ADDRESS = 'ws://studio.zignflix.com/ws/';

String SOCKET_ADDRESS = 'wss://test-api.zignflix.com/ws/';
// String SOCKET_ADDRESS = 'wss://dev-api.zignflix.com/ws/';
// String SOCKET_ADDRESS = 'wss://api.zignflix.com/ws/';
// String SOCKET_ADDRESS = 'ws://192.168.0.98:8765';
//  String SOCKET_ADDRESS = 'ws://192.168.0.67:8765';

String BASEURLMEDIA = "";
List<String> mediaTypes = ["jpeg", "mp4"];
String PLATFORM = 'WEB';
String HARDCODEPLATFORM = 'ANDROIDTV';
double gheight = 0;
double gwidth = 0;
int QUARTER_TURNS = 0;

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

String runDevice = "non_firetv";

bool alreadyAnyDownload = false;

bool HAS_ANY_OFFLINE_UNSPPOTED_MEDIA = true;
