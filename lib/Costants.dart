import 'package:connectivity_plus/connectivity_plus.dart';

String BASEURL = "https://web-dev-sgdsignage.scalgo.net";
List<String> mediaTypes = ["jpeg", "mp4"];
String PLATFORM = 'WEB';
double gheight = 0;
double gwidth = 0;


Future<bool> isOffline() async {
  final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return true;
    } else {
      return false;
    }
}


