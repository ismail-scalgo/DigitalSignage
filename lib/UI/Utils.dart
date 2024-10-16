import 'dart:convert';
import 'dart:io';
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
  // var deviceData = <String, dynamic>{};
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceType;
  try {
    if (kIsWeb) {
      final webInfo = await deviceInfoPlugin.webBrowserInfo;
      return PlatformData(webInfo.browserName.toString(),
          webInfo.appVersion.toString(), webInfo.userAgent.toString());
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return PlatformData(
            "Unknown", "Unknown", androidInfo.fingerprint.toString());
      // "Unknown", "Unknown", androidInfo.version.release.toString());
      case TargetPlatform.iOS:
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return PlatformData(
            "Unknown", "Unknown", iosInfo.systemVersion.toString());
      case TargetPlatform.windows:
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        return PlatformData(
            "Unknown", "Unknown", windowsInfo.majorVersion.toString());
      case TargetPlatform.linux:
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        return PlatformData("Unknown", "Unknown", linuxInfo.version.toString());
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
      deviceType = "Desktop";
      return deviceType;
    } else if (webInfo.userAgent!.contains("Linux")) {
      print("browser info = ${webInfo.userAgent}");
      deviceType = "Desktop";
      return deviceType;
    } else if (webInfo.userAgent!.contains("Windows")) {
      deviceType = "Desktop";
      return deviceType;
    } else if (webInfo.userAgent!.contains("iphone") ||
        webInfo.userAgent!.contains("ipad")) {
      deviceType = "iOS";
    }
  } else {
    final PlatformType currentPlatformType = PlatformDetector.platform.type;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      print("typeeeeeeeeeeeeee= ${androidInfo.model.toLowerCase()}");
      if (androidInfo.systemFeatures.contains('android.software.leanback') ||
          androidInfo.model.toLowerCase().contains('tv')) {
        deviceType = "TV";
      } else {
        deviceType = "Mobile";
      }
    } else {
      deviceType = currentPlatformType.toString().split('.').last;
    }
    return deviceType;
  }
}

Future<String> getPlatform() async {
  var deviceData = <String, dynamic>{};
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String platform;

  try {
    if (kIsWeb) {
      print("web");
      // deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      // print(deviceData);
      // print("platform = ${deviceData['platform']}");
      platform = webBrowserInfo.platform!;
      print("platform = $deviceData['platform']");
      // request.platform = platform;
      // PLATFORM = deviceData['platform'];
      return platform;
    } else {
      if (Platform.isAndroid) {
        platform = 'Android';
      } else if (Platform.isIOS) {
        platform = 'iOS';
      } else if (Platform.isWindows) {
        platform = 'Windows';
      } else if (Platform.isLinux) {
        platform = 'Linux';
      } else if (Platform.isMacOS) {
        platform = 'macOS';
      } else {
        platform = 'Unknown';
      }
      // print("platform = $platform");
      // request.platform = platform;
      return platform;
    }
  } on PlatformException {
    // deviceData['platform'] = "Unknown";
    platform = 'Unknown';
    // deviceData = <String, dynamic>{
    //   'Error:': 'Failed to get platform version.'
    // };
  }
  // if (!mounted) platform = 'Unknown';
  // setState(() {
  //   deviceData = deviceData;
  //   // print("platform = ${deviceData}");
  // });
  return platform;
}

Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  return <String, dynamic>{
    'browserName': data.browserName.name,
    'appCodeName': data.appCodeName,
    'appName': data.appName,
    'appVersion': data.appVersion,
    'deviceMemory': data.deviceMemory,
    'language': data.language,
    'languages': data.languages,
    'platform': data.platform,
    'product': data.product,
    'productSub': data.productSub,
    'userAgent': data.userAgent,
    'vendor': data.vendor,
    'vendorSub': data.vendorSub,
    'hardwareConcurrency': data.hardwareConcurrency,
    'maxTouchPoints': data.maxTouchPoints,
  };
}

void clearData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? screenCode = prefs.getString('screenCode');
  prefs.remove('screenCode');
  print("logedout code = ${prefs.getString('screenCode')}");
}
