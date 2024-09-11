import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:platform_detector/enums.dart';
import 'package:platform_detector/platform_detector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setScreenCode(String screenCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('screenCode', screenCode);
}

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> fetchLocation(double lat, double long) async {
    print(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json&addressdetails=1');
    var response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json&addressdetails=1'));
    print("response = $response");
    var data = json.decode(response.body);
    var address = data["display_name"];
    return address;
  }

  Future<PlatformData?> initPlatformState() async {
    print("entered 1");
    // var deviceData = <String, dynamic>{};
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceType;
    try {
      if (kIsWeb) {
        print("entered 2");
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        return PlatformData(webInfo.browserName.toString(),
            webInfo.appVersion.toString(), webInfo.userAgent.toString());
      }
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          print("entered 3");
          // deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
          final androidInfo = await deviceInfoPlugin.androidInfo;
          // print("info = $deviceData");
          print("info = ${androidInfo.version.baseOS.toString()}");
          return PlatformData(
              "Unknown", "Unknown", androidInfo.fingerprint.toString());
        case TargetPlatform.iOS:
          final iosInfo = await deviceInfoPlugin.iosInfo;
          return PlatformData(
              "Unknown", "Unknown", iosInfo.systemVersion.toString());
        case TargetPlatform.windows:
          final windowsInfo = await deviceInfoPlugin.windowsInfo;
          return PlatformData("Unknown", windowsInfo.csdVersion.toString(),
              windowsInfo.majorVersion.toString());
        case TargetPlatform.linux:
          final linuxInfo = await deviceInfoPlugin.linuxInfo;
          return PlatformData(
              "Unknown", "Unknown", linuxInfo.version.toString());
        case TargetPlatform.macOS:
          final macOSInfo = await deviceInfoPlugin.macOsInfo;
          return PlatformData(
              "Unknown", "Unknown", macOSInfo.majorVersion.toString());
        default:
          return PlatformData("Unknown", "Unknown", "Unknown");
      }
    } on PlatformException {
      print("'Error:': 'Failed to get platform version.'");
      return PlatformData("Unknown", "Unknown", "Unknown");
    }
  }

  Future<String?> detectDevice() async {
    var deviceData = <String, dynamic>{};
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceType;
    if (kIsWeb) {
      final webInfo = await deviceInfoPlugin.webBrowserInfo;
      if (webInfo.userAgent!.contains("Android")) {
        deviceType = "Mobile";
        return deviceType;
      } else if (webInfo.userAgent!.contains("Macintosh")) {
        deviceType = "IOS";
        return deviceType;
      } else if (webInfo.userAgent!.contains("Linux")) {
        deviceType = "Linux";
        return deviceType;
      } else if (webInfo.userAgent!.contains("Windows")) {
        deviceType = "Windows";
        return deviceType;
      } else {
        deviceType = "Unknown";
        return deviceType;
      }
    } else {
      final PlatformType currentPlatformType = PlatformDetector.platform.type;
      deviceType = currentPlatformType.toString().split('.').last;
      return deviceType;
    }
  }