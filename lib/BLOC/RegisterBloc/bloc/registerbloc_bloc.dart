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
import 'package:digitalsignange/UI/Utils.dart';
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
          setScreenCode(event.screenCode);
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
          var location = await determinePosition();
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
        // await initPlatformState();
        // // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        // // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // // print('Running on ${androidInfo.model}');
        // // WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        // // print('Running on ${webBrowserInfo.userAgent}');
        // event.request.browser = "Chrome";
        // event.request.browserVersion = "128.0.0.0";
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
}
