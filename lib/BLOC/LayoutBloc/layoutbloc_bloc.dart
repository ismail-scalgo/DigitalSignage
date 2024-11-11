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

import 'package:digitalsignange/UI/Utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
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

        if (isFirstLoad) {
          isFirstLoad = false;
          connect(event.screenCode);
        }
        screen_code = event.screenCode;
        BroadCastModel? broadCastData =
            await LayoutRepository().newFetchData(event.screenCode);
        print("data = ${broadCastData}");
        log("message = ${broadCastData?.message}");
        if (broadCastData?.message == "Screen Code doesn't exist") {
          add(LogoutEvent());
        }
        if (broadCastData?.currentBroadCast == null) {
          RELOAD_FLAG_COUNT++;
          print("no dataaaaaaaaa");
          emit(NoBroadcastState());
        } else {
          print("there is data");
          LayoutData? layoutdata = broadCastData?.currentBroadCast;
          current_broadcast = layoutdata;
          next_broadcast = broadCastData?.NextBroadCast;
          add(TrasnsitionEvent());
          String currentTime = getFormattedCurrentDateTime();
          // int startTimeDifference = timeDifference(current_broadcast!.startDateTime!, current_broadcast!.currentDatetime!);
          // int endTimeDifference = timeDifference(current_broadcast!.endDateTime!, current_broadcast!.currentDatetime!);
          int startTimeDifference =
              timeDifference(current_broadcast!.startDateTime!, currentTime);
          int endTimeDifference =
              timeDifference(current_broadcast!.endDateTime!, currentTime);
          if (currentBroadcastInString !=
                  broadCastData?.currentBroadCast?.stringData ||
              nextBroadcastInString !=
                  broadCastData!.NextBroadCast?.stringData) {
            if (HARDCODEPLATFORM != 'WEB') {
              if (startTimeDifference > 0) {
                preloadContents(current_broadcast!);
              } else if (startTimeDifference <= 0) {
                print("enteringggggggg");
                bool isCached = await allCached(current_broadcast!);
                if(!isCached) {
                  add(MediaLoadingEvent());
                }
                // String isCached = await getCachedUrl(newUrl);
                // loadContents(endTimeDifference, event.screenCode);
                try {
                  await preloadContents(current_broadcast!)
                      .timeout(Duration(seconds: endTimeDifference));
                } on TimeoutException {
                  log("Preloading timed out!");
                  add(FetchApi(screenCode: event.screenCode));
                }
                // loadContents(endTimeDifference, event.screenCode);
                // Future.delayed(Duration(seconds: endTimeDifference), () async {
                //   log("Broadcast ends");
                //   if (next_broadcast == null) {
                //     log("no broadcast");
                //     add(NoBroadCastEvent());
                //   } else {
                //     log("next broadcast");
                //     next_broadcast!.currentDatetime =
                //         current_broadcast!.endDateTime;
                //     manageBroadcast(next_broadcast!);
                //   }
                // });
              }
              if (next_broadcast != null) {
                preloadContents(next_broadcast!);
              }
            }
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

      if (event is MediaLoadingEvent) {
        if (HARDCODEPLATFORM != "WEB") {
          emit(MediaLoadingState());
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

      // if (event is CountDownEvent) {
      //   if (event.countdown <= 3) {
      //     emit(TrasitionState());
      //   } else if (event.countdown > 5) {
      //     emit(TrasitionState());
      //     await Future.delayed(Duration(seconds: 2));
      //     int countDown = event.countdown - 2;
      //     emit(DefaultScreen(countdown: countDown));
      //   } else {
      //     emit(DefaultScreen(countdown: event.countdown));
      //   }
      //   // emit(DefaultScreen(countdown: event.countdown));
      // }
      if (event is CountDownEvent) {
        if (event.countdown <= 3) {
          emit(TrasitionState());
        } else {
          emit(TrasitionState());
          await Future.delayed(Duration(seconds: 2));
          int countDown = event.countdown - 2;
          emit(DefaultScreen(countdown: countDown));
        }
      }
      if (event is NoBroadCastEvent) {
        emit(TrasitionState());
        await Future.delayed(Duration(seconds: 1));
        emit(NoBroadcastState());
      }
      if (event is DisplayBroadcastEvent) {
        emit(DisplayLayout(layoutdata: event.layoutData));
      }
      if (event is LogoutEvent) {
        print("logoutttttttttttttttttttt");
        log("first3");
        globalConnection.close();
        clearData();
        currentBroadcastInString = "";
        isFirstLoad = true;
        log("first4");
        emit(LogoutState());
      }
      if (event is TrasnsitionEvent) {
        emit(TrasitionState());
      }
      if (event is OfflineEvent) {
        emit(OfflineState());
      }

      if (event is currentBroadCastEnds) {
        print("CURRENT BROADCAST ENDS");
        log("CURRENT BROADCAST ENDS");
        if (next_broadcast == null) {
          log("no broadcast");
          add(NoBroadCastEvent());
        } else {
          log("next broadcast");
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

  void loadContents(int endTime, String screenCode) async {
    try {
      await preloadContents(current_broadcast!)
          .timeout(Duration(seconds: endTime));
    } on TimeoutException {
      log("Preloading timed out!");
      add(FetchApi(screenCode: screenCode));
    }
  }

  void manageBroadcast(LayoutData layoutdata) async {
    print("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");
    log("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");

    String currentTime = getFormattedCurrentDateTime();
    log("old current time = ${layoutdata.currentDatetime}");
    log("current time = $currentTime");

    // int start_difference = timeDifference(layoutdata.startDateTime!, layoutdata.currentDatetime!);
    int start_difference =
        timeDifference(layoutdata.startDateTime!, currentTime);
    int end_difference = 0;
    if (start_difference < 0) {
      // end_difference = timeDifference(layoutdata.endDateTime!, layoutdata.currentDatetime!);
      end_difference = timeDifference(layoutdata.endDateTime!, currentTime);
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

  String getFormattedCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return formatter.format(now);
  }

  // void preloadContents(LayoutData broadcastData) async {
  //   print("cacheiggg");
  //   broadcastData.zoneData!.forEach((zonedata) {
  //     zonedata.compositionModels.forEach((content) {
  //       DefaultCacheManager().getSingleFile(BASEURL + content.fileUrl);
  //     });
  //   });
  // }
  Future<bool> allCached(LayoutData broadcastData) async {
    print("check cachinggg");
    bool isAllCached = true;
    var cachedFile;
    final cacheManager = DefaultCacheManager();
    for (var zoneData in broadcastData.zoneData!) {
      for (var content in zoneData.compositionModels) {
        // var file = await DefaultCacheManager().getSingleFile(BASEURL + content.fileUrl);
        cachedFile = await cacheManager.getFileFromCache(BASEURL + content.fileUrl);
        if (cachedFile == null) {
          isAllCached = false;
          break;
        }
      }
      if (!isAllCached) {
          break;
      }
    }
    return isAllCached;

    // final cachedFile = await cacheManager.getFileFromCache(newUrl);
    // return cachedFile.toString();

    // if (cachedFile != null) {
    //     print("File is cached: ${cachedFile.file.path}");
    //  } else {
    //   print("File is not cached: $newUrl");
    // }
  }

  Future preloadContents(LayoutData broadcastData) async {
    print("cacheiggg");
    for (var zoneData in broadcastData.zoneData!) {
      for (var content in zoneData.compositionModels) {
      var file=  await DefaultCacheManager().getSingleFile(BASEURL + content.fileUrl);
    
      }
      ;
    }
    ;
  }
}
