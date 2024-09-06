// ignore_for_file: depend_on_referenced_packages, unnecessary_import

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/REPOSITORIES/LoginRepository.dart';
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
        var loginRes;
        final LoginRepository apiRepo = await LoginRepository();
        loginRes = apiRepo.fetchLogin();
        print("login reponse = $loginRes");
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
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        try {
          var location = await _determinePosition();
          var address =
              await fetchResponse(location.latitude, location.longitude);
          event.request.latitude = location.latitude.toString();
          event.request.longitude = location.longitude.toString();
          event.request.location = address;
        } catch (e) {
          print(e);
          emit(PermissionDenied());
          return;
        }
        print("start");
        await initPlatformState();
        // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // print('Running on ${androidInfo.model}');
        // WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
// print('Running on ${webBrowserInfo.userAgent}');
        event.request.browser = "Chrome";
        event.request.browserVersion = "128.0.0.0";
        event.request.orientation = "landscape";
        event.request.osVersion = "windows-10";
        event.request.type = "Desktop";
        try {
          final RegisterRepository apiRepo = RegisterRepository();
          String? Stat = await apiRepo.registerScreen(event.request);
          print(Stat);
          emit(SuccessState());
        } catch (e) {
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();
          // print(e);
          emit(FailureState(message: errorMessage));
          // print( "error = $e.");
          // emit(FailureState(message: e.toString()));
        }
        // responseData = await apiRepo.registerScreen(event.request);
      }
    });
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        deviceData = readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
        // deviceData.
        print("web = $deviceData");
      }
      //else {
      //   deviceData = switch (defaultTargetPlatform) {
      //     TargetPlatform.android =>
      //       _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
      //     TargetPlatform.iOS =>
      //       _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
      //     TargetPlatform.linux =>
      //       _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
      //     TargetPlatform.windows =>
      //       _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
      //     TargetPlatform.macOS =>
      //       _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
      //     TargetPlatform.fuchsia => <String, dynamic>{
      //         'Error:': 'Fuchsia platform isn\'t supported'
      //       },
      //   };
      // }
    } on PlatformException {
      // deviceData = <String, dynamic>{
      // 'Error:': 'Failed to get platform version.'
      print("'Error:': 'Failed to get platform version.'");
    }
    ;
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

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
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
      // 'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> readWebBrowserInfo(WebBrowserInfo data) {
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

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }
}
