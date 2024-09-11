import 'package:connectivity_plus/connectivity_plus.dart';

String BASEURL = "https://web-dev-sgdsignage.scalgo.net";
List<String> mediaTypes = ["jpeg", "mp4"];
String CURRENT_PLATFORM = "Web";


Future<bool> isOffline() async {
  final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return true;
    } else {
      return false;
    }
}
//String BASEURL = "https://web-dev-sgdsignage.scalgo.net";
// String BASEURL = "";
// List<String> mediaTypes = ["jpeg", "mp4"];

double gheight = 0;
double gwidth = 0;

String PLATFORM = 'ANDROID';
