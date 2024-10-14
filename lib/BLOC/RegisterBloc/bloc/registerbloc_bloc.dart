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
        var loginRes;
        String? codeErr;
        if (event.screenCode.trim().isEmpty) {
          codeErr = "Screen Code is required";
        }
        if (codeErr != null) {
          emit(RegisterblocState(screenCodeErr: codeErr));
          return;
        }
        print("tryinggggggggggggg");
        try {
          emit(LoginLoadingState());
          print("tryingggggggggggggggggggggggg");
          final LoginRepository apiRepo = LoginRepository();
          // loginRes = await apiRepo.fetchLogin(event.screenCode);
          String? stat = await apiRepo.fetchLogin(event.screenCode);
          if (stat == "NoData") {
            print("NoData");
          }
          print("login reponse = $loginRes");
          emit(LaunchScreen(code: event.screenCode));
          setScreenCode(event.screenCode);
        } catch (e) {
          print("new err = $e");
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();
          if (errorMessage != "Screen Code doesn't exist") {
            errorMessage = "Network Error";
          }
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
        if (HARDCODEPLATFORM != "ANDROIDTV") {
          try {
            emit(RegisterLoadingState());
            print("start");
            var location = await determinePosition();
            print("stop");
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
        } else {
          emit(RegisterLoadingState());
          print("ANDROID TV");
          event.request.latitude = "8.55";
          event.request.longitude = "76.88";
          event.request.location = "Karyavattom, trivandrum";
        }
        Future setVersions() async {
          PlatformData? platformInfo = await initPlatformState();
          if (HARDCODEPLATFORM == "WEB") {
            event.request.browser = platformInfo?.browser;
            event.request.browserVersion = platformInfo?.browserVersion;
          }
          event.request.osVersion = platformInfo?.osVersion;
        }

        await setVersions();
        event.request.orientation = "landscape";
        event.request.type = await detectDevice();
        print("info = ${event.request.browser}");
        print("info = ${event.request.browserVersion}");
        print("info = ${event.request.osVersion}");
        print("info = ${event.request.type}");
        try {
          print("calling api");
          final RegisterRepository apiRepo = RegisterRepository();
          String? Stat = await apiRepo.registerScreen(event.request);
          print(Stat);
          emit(SuccessState());
        } catch (e) {
          print(e);
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();
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
