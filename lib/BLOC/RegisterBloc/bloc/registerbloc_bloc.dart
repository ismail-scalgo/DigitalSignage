// ignore_for_file: depend_on_referenced_packages, unnecessary_import

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/REPOSITORIES/RegisterRepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'registerbloc_event.dart';
part 'registerbloc_state.dart';

class RegisterblocBloc extends Bloc<RegisterblocEvent, RegisterblocState> {
  late String platform;
  RegisterblocBloc() : super(RegisterblocInitial()) {
    on<RegisterblocEvent>((event, emit) async {
      if (event is LoginUser) {
        emit(LaunchScreen());
      }
      if (event is ShowSignIn) {
        emit(SignInScreen());
      }
      if (event is ShowRegister) {
        emit(DisplayRegistration());
      }
      if (event is RegisterUser) {
        final Data? responseData;
        var location = await _determinePosition();
        // var currentPlatform = await initPlatformState();
        var address =
            await fetchResponse(location.latitude, location.longitude);
        // event.request.

        print("request = ${event.request.agentId}");
        print("request = ${event.request.name}");
        print("request = ${event.request.height}");
        print("request = ${event.request.width}");
        print("request = ${event.request.latitude}");
        print("request = ${event.request.longitude}");
        print("request = ${event.request.location}");
        print("request = ${event.request.platform}");

        final RegisterRepository apiRepo = RegisterRepository();
        responseData = await apiRepo.registerScreen(event.request);
        // print("request = ${event.request}");
        // print("name = ${event.request.name}");
      }
    });
  }

  Future<Position> _determinePosition() async {
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

  // Future<String> initPlatformState() async {
  //   var deviceData = <String, dynamic>{};

  //   try {
  //     if (kIsWeb) {
  //       deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
  //       // print(deviceData);
  //       // print("platform = ${deviceData['platform']}");
  //       // platform = deviceData['platform'];
  //       // request.platform = platform;
  //       return deviceData['platform'];
  //     } else {
  //       if (Platform.isAndroid) {
  //         platform = 'Android';
  //       } else if (Platform.isIOS) {
  //         platform = 'iOS';
  //       } else if (Platform.isWindows) {
  //         platform = 'Windows';
  //       } else if (Platform.isLinux) {
  //         platform = 'Linux';
  //       } else if (Platform.isMacOS) {
  //         platform = 'macOS';
  //       } else {
  //         platform = 'Unknown';
  //       }
  //       // print("platform = $platform");
  //       // request.platform = platform;
  //       return platform;
  //     }
  //   } on PlatformException {
  //     deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }
  //   // if (!mounted) return "";
  //     deviceData = deviceData;
  //   return platform;
  // }

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

  Future<String> fetchResponse(double lat, double long) async {
    var response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json&addressdetails=1'));
    // print("data= ${response.body}");
    print("response = $response");
    var data = json.decode(response.body);
    var address = data["display_name"];
    // print("response = $address");
    // request.location = address;
    return address;
  }
}
