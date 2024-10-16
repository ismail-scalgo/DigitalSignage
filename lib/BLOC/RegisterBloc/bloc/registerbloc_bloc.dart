// ignore_for_file: depend_on_referenced_packages, unnecessary_import, body_might_complete_normally_nullable, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/ContentModel.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'registerbloc_event.dart';
part 'registerbloc_state.dart';

class RegisterblocBloc extends Bloc<RegisterblocEvent, RegisterblocState> {
  late String platform;
  late WebSocket globalConnection;

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
        if (event.request.agentId!.trim().isEmpty) {
          agentIdErr = "AgentId is required";
        }
        if (event.request.name!.trim().isEmpty) {
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
          event.request.browser = platformInfo?.browser;
          event.request.browserVersion = platformInfo?.browserVersion;
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
          final RegisterRepository registerRepo = RegisterRepository();
          String? Stat = await registerRepo.registerScreen(event.request);
          print(Stat);
          emit(SuccessState());
        } catch (e) {
          print(e);
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();
          emit(FailureState(message: errorMessage));
        }
      }
      if (event is GetScreenCode) {
        print("entering event");
        if (HARDCODEPLATFORM != "ANDROIDTV") {
          try {
            print("entering location");
            // emit(RegisterLoadingState());
            var location = await determinePosition();
            var address =
                await fetchLocation(location.latitude, location.longitude);
            event.request.latitude = location.latitude.toString();
            event.request.longitude = location.longitude.toString();
            event.request.location = address;
          } catch (e) {
            print(e);
            event.request.latitude = "8.55";
            event.request.longitude = "76.88";
            event.request.location = "Karyavattom, trivandrum";
          }
        } else {
          event.request.latitude = "Unknown";
          event.request.longitude = "Unknown";
          event.request.location = "Unknown";
        }
        try {
          print("calling apiss");
          event.request.name = "Unknown";
          event.request.platform = await getPlatform() ?? "Unknown";
          event.request.type = await detectDevice() ?? "Unknown";
          print("platform = ${event.request.platform}");
          event.request.osVersion = "Unknown";
          event.request.browser = "Unknown";
          event.request.browserVersion = "Unknown";
          event.request.orientation = "0";
          event.request.agentId = "Unknown";
          print("requestinggg");
          final RegisterRepository registerRepo = RegisterRepository();
          print("requestinggg");
          print("data1 = ${event.request.name}");
          print("data1 = ${event.request.platform}");
          print("data1 = ${event.request.type}");
          print("data1 = ${event.request.osVersion}");
          print("data1 = ${event.request.browser}");
          print("data1 = ${event.request.browserVersion}");
          print("data1 = ${event.request.orientation}");
          print("data1 = ${event.request.agentId}");
          print("data1 = ${event.request.latitude}");
          print("data1 = ${event.request.longitude}");
          print("data1 = ${event.request.location}");
          print("data1 = ${event.request.height}");
          print("data1 = ${event.request.width}");

          String? screenCode =
              await registerRepo.fetchScreenCode(event.request);
          print(screenCode);
          connect(screenCode!);
          emit(DisplayNewScreenCode(screenCode: screenCode!));
        } catch (e) {
          print(e);
        }
      }

      if (event is DisplayScreenCode) {
        connect(event.screenCode);
        // print("emitting old");
        // emit(DisplayOldScreenCode(screenCode: event.screenCode));
        // connect(event.screenCode);
        try {
          final RegisterRepository registerRepo = RegisterRepository();
          print("requestinggg");
          ScreenCodeModel? data =
              await registerRepo.checkScreenCode(event.screenCode);
          print("data = ${data?.agentId}");
          print("data = ${data?.isRegistered}");
          print("data = ${data?.message}");
          if (!data!.isRegistered!) {
            print("emitting old");
            emit(DisplayOldScreenCode(screenCode: event.screenCode));
          }
          if (data!.isRegistered!) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setBool('isRegistered', true);
            print("launchingggg");
            closeConnection();
            // globalConnection.close();
            print("launchingggg");
            emit(LaunchScreen(code: event.screenCode));
          }
        } catch (e) {}
      }

      if (event is ConnectSocket) {
        connect(event.screenCode);
      }

      if (event is LaunchSignage) {
        emit(LaunchScreen(code: event.screenCode));
      }
    });
  }

  void connect(String screencode) async {
    final socket = WebSocket(Uri.parse(SOCKET_ADDRESS));
    globalConnection = socket;
    socket.messages.listen((message) async {
      print("socket message = $message");
      var jsonresponce = jsonDecode(message);
      print("socket response = $jsonresponce");
      print("socket updated time = ${jsonresponce['updated_at']}");
      log("socket response = $jsonresponce");
      log("socket updated time = ${jsonresponce['updated_at']}");
      add(DisplayScreenCode(screenCode: screencode));
    }, onError: (error) {
      print("Error receiving message: $error");
    });

    socket.send('ping');
    socket.connection.listen(
      (connectionState) {
        if (connectionState is Connecting) {
          print("CONNECTING");
        }
        if (connectionState is Connected) {
          print("CONNECTED");
          String formattedScreenCode = '"' + screencode + '"';
          print('{"screen_code" : $formattedScreenCode}');
          socket.send(
              // '{"screen_code" : $formattedScreenCode, "client_type" : "device"}'
              '{"client_type":"device","screen_code":$formattedScreenCode}');
          print("sended");
        }
        if (connectionState is Disconnected) {
          print("DISCONNECTED");
        }
        if (connectionState is Reconnecting) {
          print("RECONNECTING");
        }
        if (connectionState is Reconnected) {
          print("RECONNECTED");
          String formattedScreenCode = '"' + screencode + '"';
          print('{"screen_code" : $formattedScreenCode}');
          socket.send(
              '{"screen_code" : $formattedScreenCode, "client_type" : "device"}');
          add(DisplayScreenCode(screenCode: screencode));
        }
        print("connection state ${connectionState.toString()}");
      },
    );
  }

  void closeConnection() {
    if (globalConnection != null) {
      try {
        globalConnection.close();
        print("WebSocket connection closed.");
      } catch (e) {
        print("Error while closing WebSocket: $e");
      }
    } else {
      print("WebSocket is not initialized or already closed.");
    }
  }
}
