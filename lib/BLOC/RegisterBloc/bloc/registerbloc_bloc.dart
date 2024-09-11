// ignore_for_file: depend_on_referenced_packages, unnecessary_import, body_might_complete_normally_nullable, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/REPOSITORIES/LoginRepository.dart';
import 'package:digitalsignange/REPOSITORIES/RegisterRepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:platform_detector/enums.dart';
import 'package:platform_detector/platform_detector.dart';

part 'registerbloc_event.dart';
part 'registerbloc_state.dart';

class RegisterblocBloc extends Bloc<RegisterblocEvent, RegisterblocState> {
  late String platform;
  RegisterblocBloc() : super(RegisterblocInitial()) {
    on<RegisterblocEvent>((event, emit) async {
      if (event is LoginUser) {
        print("login event callinggg...");
        var loginRes;
        try {
          final LoginRepository apiRepo = LoginRepository();
          // loginRes = await apiRepo.fetchLogin(event.screenCode);
          String? stat = await apiRepo.fetchLogin(event.screenCode);
          print("login reponse = $loginRes");
          emit(LaunchScreen());
        } catch (e) {
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();
          // print(e);
          emit(loginFailureState(message: errorMessage));
        }
      }
      if (event is ShowSignIn) {
        emit(SignInScreen());
      }
      if (event is ShowRegister) {
        emit(DisplayRegistration());
      }
      if (event is RegisterUser) {
        print("Register event callinggg...");
        final Data? responseData;
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

        String? agentIdErr;
        String? nameErr;
        if (event.request.agentId.trim().isEmpty) {
          agentIdErr = "AgentId is required";
        }
        if (event.request.name.trim().isEmpty) {
          nameErr = "Screen Name is required";
        }
        if (agentIdErr != null || nameErr != null) {
          emit(RegisterblocState(agentIdErr: agentIdErr, nameErr: nameErr));
          return;
        }

        try {
          var location = await _determinePosition();
          var address =
              await fetchLocation(location.latitude, location.longitude);
          event.request.latitude = location.latitude.toString();
          event.request.longitude = location.longitude.toString();
          event.request.location = address;
        } catch (e) {
          print(e);
          final PlatformType currentPlatformName =
              PlatformDetector.platform.type;
          emit(PermissionDenied());
          return;
        }
        Future setVersions() async {
          print("entered");
          PlatformData? platformInfo = await initPlatformState();
          event.request.browser = platformInfo?.browser;
          event.request.browserVersion = platformInfo?.browserVersion;
          event.request.osVersion = platformInfo?.osVersion;
          // event.request.type = PlatformDetector.platform.type.toString();
          // String platformType = PlatformDetector.platform.type.toString();
          // String result = platformType.split('.').last;
          // print("type = $result");
          // event.request.type = platformInfo?.type;
        }

        print("start");
        await setVersions();
        event.request.orientation = "landscape";
        event.request.type = await detectDevice();
        print("info = ${event.request.browser}");
        print("info = ${event.request.browserVersion}");
        print("info = ${event.request.osVersion}");
        print("info = ${event.request.type}");
        try {
          final RegisterRepository apiRepo = RegisterRepository();
          String? Stat = await apiRepo.registerScreen(event.request);
          print(Stat);
          emit(SuccessState());
        } catch (e) {
          print(e);
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();
          // print(e);
          emit(FailureState(message: errorMessage));
        }
      }
    });
  }

  // if (!mounted) return;
  // setState(() {
  //   _deviceData = deviceData;
  // });
  // }

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
    var deviceData = <String, dynamic>{};
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
          deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
          final androidInfo = await deviceInfoPlugin.androidInfo;
          print("info = $deviceData");
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
}

Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'serialNumber': build.serialNumber,
  };
}
