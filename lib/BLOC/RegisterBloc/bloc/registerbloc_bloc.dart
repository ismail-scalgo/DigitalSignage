// ignore_for_file: depend_on_referenced_packages, unnecessary_import, body_might_complete_normally_nullable, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:player/Costants.dart';
import 'package:player/MODELS/ContentModel.dart';
import 'package:player/MODELS/RequestModel.dart';
import 'package:player/MODELS/ResponseDataModel.dart';
import 'package:player/MODELS/ScreenCodeModel.dart';

import 'package:player/REPOSITORIES/RegisterRepo.dart';
import 'package:player/UI/Utils.dart';
import 'package:display_metrics/display_metrics.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:player/Utils.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'registerbloc_event.dart';
part 'registerbloc_state.dart';

class RegisterblocBloc extends Bloc<RegisterblocEvent, RegisterblocState> {
  late WebSocket globalConnection;
  late StreamSubscription internetlistener;

  bool isfirsttime = true;
  BuildContext? context;
  bool isWebSocketConnected = false;

  RegisterblocBloc() : super(RegisterblocInitial()) {
    DebugPrint("REGISTRATION BLOC INITIALISED");
    on<RegisterblocEvent>((event, emit) async {
      DebugPrint("BLOC CALLED WITH EVENT");
      DebugPrint(event);
      if (event is AddContext) {
        DebugPrint("ADD CONTEXT CALLLEDDDDDDDDDDDDDDDDDD");
        context = event.context;
      }

      if ((event is InterNetStatusEvent) && isfirsttime) {
        isfirsttime = false;
        interNetConnectionManger();
      } else if ((event is InterNetStatusEvent) && !isfirsttime) {
        if (await InternetConnection().hasInternetAccess) {
          add(CheckDeviceStatusEvent());
        } else {
          add(OfflineEvent());
        }
      }

      if (event is CheckDeviceStatusEvent) {
        DebugPrint("from reg bloc");
        DebugPrint("CheckDeviceStatusEvent");

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        String? screenCode = prefs.getString('NewScreenCode');
        bool? isRegistered = prefs.getBool('isRegistered');
        if (isRegistered == null) {
          isRegistered = false;
        }

        if (screenCode == null) {
          add(GetScreenCode());
        } else if (!isRegistered) {
          add(DisplayScreenCode(screenCode: screenCode));
        } else {
          DebugPrint("got it");
          updateScreenCodeStatus(screenCode);
          add(LaunchSignage(screenCode: screenCode));
        }
      }

      if (event is GetScreenCode) {
        if (await isOffline()) {
          add(OfflineEvent());
        } else {
          String agentId = "Unknown";
          String name = "Unknown";
          String browser = "Unknown";
          String browserVersion = "Unknown";
          String latitude = "0.0";
          String longitude = "0.0";
          String location = "Unknown";
          String orientation = "0";

          String height = "0";
          String width = "0";
          String type = "Unknown";
          String osVersion = "Unknown";
          String platform = "Unknown";

          platform = getPlatform();

          final metrics = DisplayMetrics.of(context!);
          height = metrics.resolution.height.toString();
          width = metrics.resolution.width.toString();
          DebugPrint(metrics.resolution.height);
          DebugPrint(metrics.resolution.width);

          if (HARDCODEPLATFORM == "WEB") {
            PlatformData? platformInfo = await initPlatformState();
            String browser = platformInfo!.browser;
            String browserVersion = platformInfo.browserVersion;
            Position position = await determinePosition();
            latitude = position.latitude.toString();
            longitude = position.longitude.toString();
            location = await fetchLocation(
              position.latitude,
              position.longitude,
            );
          }
          if (HARDCODEPLATFORM == "ANDROIDTV") {
            bool tvMode = await PlatformTVCheck.isTV();
            bool serviceEnabled = false;
            if (!tvMode) {
              serviceEnabled = await Geolocator.isLocationServiceEnabled();
            }
            

            if (serviceEnabled) {
              try {
                Position position = await determinePosition();
                latitude = position.latitude.toString();
                longitude = position.longitude.toString();
              } catch (e) {}

              // location =
              //     await fetchLocation(position.latitude, position.longitude);
              location = "Unknown";
            }

            type = (await detectDevice()) ?? "Unknown";

            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

            AndroidDeviceInfo info = await deviceInfo.androidInfo;

            osVersion = info.version.sdkInt.toString();
          }

          RequestModel requestModel = RequestModel(
            agentId: agentId,
            name: name,
            browser: browser,
            browserVersion: browserVersion,
            location: location,
            latitude: latitude,
            longitude: longitude,
            orientation: orientation,
            platform: platform,
            osVersion: osVersion,
            height: width,
            width: height,
            type: type,
          );
          try {
            FetchScreenCodeModel? screenCodeModel = await RegisterRepository()
                .fetchScreenCode(requestModel);
            screenCodeModel!.screenCode != null
                ? saveNewScreenCode(
                  screenCodeModel.screenCode!,
                  screenCodeModel.secretKey!,
                )
                : DebugPrint('');

            if (!isWebSocketConnected) {
              connect(screenCodeModel.screenCode!);
              isWebSocketConnected = true;
            }

            emit(
              DisplayScreenCodeState(screenCode: screenCodeModel.screenCode!),
            );
          } catch (e) {
            DebugPrint(e);
          }
        }
      }
      if (event is DisplayScreenCode) {
        if (await isOffline()) {
          add(OfflineEvent());
        } else {
          if (!isWebSocketConnected) {
            connect(event.screenCode!);
            isWebSocketConnected = true;
          }
          // connect(event.screenCode);
          // DebugPrint("emitting old");
          // emit(DisplayOldScreenCode(screenCode: event.screenCode));
          // connect(event.screenCode);
          try {
            final RegisterRepository registerRepo = RegisterRepository();
            DebugPrint("requestinggg");
            ScreenCodeModel? data = await registerRepo.checkScreenCode(
              event.screenCode,
            );
            DebugPrint("data = ${data?.agentId}");
            DebugPrint("data = ${data?.isRegistered}");
            DebugPrint("data = ${data?.message}");
            if (!data!.isRegistered!) {
              DebugPrint("emitting old");
              emit(DisplayScreenCodeState(screenCode: event.screenCode));
            }
            if (data.isRegistered!) {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setBool('isRegistered', true);
              closeConnection();
              await internetlistener.cancel();
              emit(LaunchScreen(code: event.screenCode));
            }
          } catch (e) {}
        }
      }
      if (event is ConnectSocket) {
        if (!isWebSocketConnected) {
          connect(event.screenCode!);
          isWebSocketConnected = true;
        }
      }
      if (event is OfflineEvent) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        String? screenCode = prefs.getString('NewScreenCode');
        bool? isRegistered = prefs.getBool('isRegistered');
        if (isRegistered == null) {
          isRegistered = false;
        }

        if (screenCode != null && isRegistered) {
          add(LaunchSignage(screenCode: screenCode));
        } else {
          emit(OfflineState());
        }
      }
      if (event is LaunchSignage) {
        emit(LaunchScreen(code: event.screenCode));
      }
    });
  }

  void saveNewScreenCode(String screenCode, String secretKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('NewScreenCode', screenCode);
    await prefs.setString('secretKey', secretKey);
    await prefs.setBool('isRegistered', false);
  }

  void updateScreenCodeStatus(String screenCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('NewScreenCode', screenCode);
    await prefs.setBool('isRegistered', true);
  }

  void connect(String screencode) async {
    DebugPrint("WEB SOCKET CONNECTION ON REG SCREEN CALLED");
    final socket = WebSocket(Uri.parse(SOCKET_ADDRESS));
    globalConnection = socket;
    socket.messages.listen(
      (message) async {
        DebugPrint("socket message = $message");
        var jsonresponce = jsonDecode(message);
        DebugPrint("socket response = $jsonresponce");
        add(DisplayScreenCode(screenCode: screencode));
      },
      onError: (error) {
        DebugPrint("Error receiving message: $error");
      },
    );

    socket.send('ping');
    socket.connection.listen((connectionState) {
      if (connectionState is Connecting) {
        DebugPrint("CONNECTING");
      }
      if (connectionState is Connected) {
        DebugPrint("CONNECTED");
        String formattedScreenCode = '"' + screencode + '"';
        DebugPrint('{"screen_code" : $formattedScreenCode}');
        socket.send(
          // '{"screen_code" : $formattedScreenCode, "client_type" : "device"}'
          '{"client_type":"device","screen_code":$formattedScreenCode,"is_registered":"false"}',
        );
        DebugPrint("sended");
      }
      if (connectionState is Disconnected) {
        DebugPrint("DISCONNECTED");
      }
      if (connectionState is Reconnecting) {
        DebugPrint("RECONNECTING");
      }
      if (connectionState is Reconnected) {
        DebugPrint("RECONNECTED");
        String formattedScreenCode = '"' + screencode + '"';
        DebugPrint('{"screen_code" : $formattedScreenCode}');
        socket.send(
          '{"screen_code" : $formattedScreenCode, "client_type" : "device","is_registered":"false"}',
        );
        add(DisplayScreenCode(screenCode: screencode));
      }
      DebugPrint("connection state ${connectionState.toString()}");
    });
  }

  void closeConnection() {
    if (globalConnection != null) {
      try {
        globalConnection.close();
        isWebSocketConnected = false;
        DebugPrint("WEB SOCKET CONNECTION CLOSED ON REG SCREEN CALLED");
      } catch (e) {
        DebugPrint("Error while closing WebSocket: $e");
      }
    } else {
      DebugPrint("WebSocket is not initialized or already closed.");
    }
  }

  void interNetConnectionManger() {
    internetlistener = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      switch (status) {
        case InternetStatus.connected:
          add(CheckDeviceStatusEvent());
          break;
        case InternetStatus.disconnected:
          add(OfflineEvent());
          break;
      }
    });
  }
}
