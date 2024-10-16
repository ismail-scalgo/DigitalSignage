// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/BroadCastModel.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';
import 'package:digitalsignange/REPOSITORIES/XcompositionRepository.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'layoutbloc_event.dart';
part 'layoutbloc_state.dart';

class LayoutblocBloc extends Bloc<LayoutblocEvent, LayoutblocState> {
  bool isLocked = false;
  bool isFirstLoad = true;
  late String lastUpdateTime = "NO TIME";
  String? currentBroadcastInString;
  String? nextBroadcastInString;
  LayoutData? current_broadcast;
  LayoutData? next_broadcast;
  String? screen_code;
  late WebSocket globalConnection;

//if any time it is reloaded then any timer scheduled will not work
//it will check usig reload variable
  int RELOAD_FLAG_COUNT = 0;

  LayoutblocBloc() : super(LayoutblocInitial()) {
    print("bloc created");
    on<LayoutblocEvent>((event, emit) async {
      if (event is FetchApi) {
        print("fetch api event called");
        screen_code = event.screenCode;
        BroadCastModel? broadCastData =
            await LayoutRepository().newFetchData(event.screenCode);
        print(isFirstLoad);
        if (isFirstLoad) {
          print("connectingggg");
          isFirstLoad = false;
          connect(event.screenCode);
        }
        print("goinggggggggggggggggggggggggggggggggggggggg");
        print("data = ${broadCastData}");
        if (broadCastData?.currentBroadCast == null) {
          RELOAD_FLAG_COUNT++;
          print("no dataaaaaaaaa");
          emit(NoBroadcastState());
        } else {
          print("there is data");
          LayoutData? layoutdata = broadCastData?.currentBroadCast;
          current_broadcast = layoutdata;
          next_broadcast = broadCastData?.NextBroadCast;

          if (HARDCODEPLATFORM != 'WEB') {
            preloadContents(current_broadcast!);
            if (next_broadcast != null) {
              preloadContents(next_broadcast!);
            }
          }

          if (currentBroadcastInString !=
                  broadCastData?.currentBroadCast?.stringData ||
              nextBroadcastInString !=
                  broadCastData!.NextBroadCast?.stringData) {
            add(TrasnsitionEvent());
            await Future.delayed(Duration(seconds: 1));
            print("data changingggggggggg");
            RELOAD_FLAG_COUNT++;
            currentBroadcastInString =
                broadCastData!.currentBroadCast?.stringData!;
            nextBroadcastInString = broadCastData.NextBroadCast?.stringData!;
            print("update = ${layoutdata!.lastUpdatedAt}");
            lastUpdateTime = layoutdata.lastUpdatedAt!;
            manageBroadcast(current_broadcast!);
          }
        }
      }

      if (event is StartEvent) {
        emit(DisplayLayout(layoutdata: event.layoutdata));
      }
      if (event is EndEvent) {
        emit(NoBroadcastState());
      }
      if (event is visibleButton) {
        emit(DisplayButton(isvisible: event.isvisible));
      }

      if (event is CountDownEvent) {
        emit(DefaultScreen(countdown: event.countdown));
      }

      if (event is NoBroadCastEvent) {
        emit(NoBroadcastState());
      }

      if (event is DisplayBroadcastEvent) {
        emit(DisplayLayout(layoutdata: event.layoutData));
      }
      if (event is LogoutEvent) {
        print("logoutttttttttttttttttttt");
        currentBroadcastInString = "";
        // globalConnection.close();
      }
      if (event is TrasnsitionEvent) {
        emit(TrasitionState());
      }

      if (event is currentBroadCastEnds) {
        print("CURRENT BROADCAST ENDS");

        if (next_broadcast == null) {
          add(NoBroadCastEvent());
        } else {
          next_broadcast!.currentDatetime = event.current_datetime;
          manageBroadcast(next_broadcast!);
        }
        await Future.delayed(Duration(seconds: 2));
        BroadCastModel? broadCastData =
            await LayoutRepository().newFetchData(screen_code!);
        LayoutData? layoutdata = broadCastData?.currentBroadCast;
        current_broadcast = layoutdata;
        next_broadcast = broadCastData?.NextBroadCast;
        if (HARDCODEPLATFORM != 'WEB') {
          if (next_broadcast != null) {
            preloadContents(next_broadcast!);
          }
        }

        if (current_broadcast == null) {
          currentBroadcastInString = '';
        } else {
          currentBroadcastInString =
              broadCastData!.currentBroadCast!.stringData!;
        }
        if (broadCastData!.NextBroadCast == null) {
          nextBroadcastInString = '';
        } else {
          nextBroadcastInString = broadCastData.NextBroadCast!.stringData!;
        }
      }
    });
  }

  void manageBroadcast(LayoutData layoutdata) async {
    print("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");
    log("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");

    int start_difference =
        timeDifference(layoutdata.startDateTime!, layoutdata.currentDatetime!);
    int end_difference = 0;
    if (start_difference < 0) {
      end_difference =
          timeDifference(layoutdata.endDateTime!, layoutdata.currentDatetime!);
    } else {
      end_difference =
          timeDifference(layoutdata.endDateTime!, layoutdata.startDateTime!);
    }
    print("START TIME DIFFERENCEEEEEEEEEEEEEE  $start_difference");

    print("END TIME DIFFERENCEEEEEEEEEEEEEE  $end_difference");

    int current_reload_flag_count = RELOAD_FLAG_COUNT;

    if (start_difference > 0) {
      log("Countdown started");
      add(CountDownEvent(countdown: start_difference));

      await Future.delayed(Duration(seconds: start_difference), () {
        if (current_reload_flag_count == RELOAD_FLAG_COUNT) {
          add(DisplayBroadcastEvent(layoutData: layoutdata));
        }
      });

      await Future.delayed(Duration(seconds: end_difference), () {
        if (current_reload_flag_count == RELOAD_FLAG_COUNT) {
          print("new event added1");
          add(currentBroadCastEnds(current_datetime: layoutdata.endDateTime!));
        }
      });
    } else if (start_difference <= 0 && end_difference > 0) {
      print("new event added2");
      add(DisplayBroadcastEvent(layoutData: layoutdata));
      await Future.delayed(Duration(seconds: end_difference), () {
        if (current_reload_flag_count == RELOAD_FLAG_COUNT) {
          add(currentBroadCastEnds(current_datetime: layoutdata.endDateTime!));
        }
      });
    } else if (end_difference <= 0) {
      add(NoBroadCastEvent());
    }
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
      log("laaaaaaaaaaaaaaaaaaaast updated = $lastUpdateTime");
      if (lastUpdateTime != jsonresponce['updated_at']) {
        log("Time changeddddddddddddddddddddddddddddddddddddddddddd");
        lastUpdateTime = jsonresponce['updated_at'];
        add(FetchApi(screenCode: screencode));
      }
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
              '{"screen_code" : $formattedScreenCode, "client_type" : "device"}');
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
          add(FetchApi(screenCode: screencode));
        }
        print(connectionState.toString());
      },
    );
  }

  int timeDifference(String time, String curretTime) {
    DateTime givenDateTime = DateTime.parse(time);
    DateTime now = DateTime.parse(curretTime);
    Duration difference = givenDateTime.difference(now);
    return difference.inSeconds;
  }

  void preloadContents(LayoutData broadcastData) async {
    print("cacheiggg");
    broadcastData.zoneData!.forEach((zonedata) {
      zonedata.compositionModels.forEach((content) {
        DefaultCacheManager().getSingleFile(BASEURL + content.fileUrl);
      });
    });
  }
}
