// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:digitalsignange/CONTENTLOG.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/LOGS.dart';
import 'package:digitalsignange/MODELS/BroadCastModel.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';
import 'package:digitalsignange/REPOSITORIES/XcompositionRepository.dart';
import 'package:digitalsignange/UI/NoInternetScreen.dart';

import 'package:digitalsignange/UI/Utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  StreamSubscription<FileResponse>? lastDownloadingFile;

  int? systemToServerTimeDifference;

  // final downloadController = StreamController<LayoutData>();

  int lastdownloadprogress = 0;
  //if any time it is reloaded then any timer scheduled will not work
  //it will check usig reload variable
  int RELOAD_FLAG_COUNT = 0;

  int QUICK_BROADCAST_COUNT = 0;

  LayoutblocBloc() : super(LayoutblocInitial()) {
    print("LAYOUT BLOC CALLEDDDDDDDDD");
    log_of_start_stop();

    on<LayoutblocEvent>((event, emit) async {
      print("LAYOU BLOCK EVENT");
      print(event);
      if (event is FetchApi) {
        log("fetch api event called");
        print("fetch api event called");

        if (isFirstLoad) {
          await init();
          connect(event.screenCode);
        }
        bool result = await InternetConnection().hasInternetAccess;

        if (result) {
          screen_code = event.screenCode;
          BroadCastModel? broadCastData =
              await LayoutRepository().newFetchData(event.screenCode);

          if (broadCastData?.message == "Screen Code doesn't exist") {
            add(LogoutEvent());
          }
          if (broadCastData?.currentBroadCast == null) {
            RELOAD_FLAG_COUNT++;

            emit(NoBroadcastState());
          } else {
            print("there is data");
            if (broadCastData?.currentBroadCast != null) {
              await saveTimedifference(
                  (broadCastData?.currentBroadCast!.currentDatetime)!);
              systemToServerTimeDifference = await gettimedifference();
            }
            LayoutData? layoutdata = broadCastData?.currentBroadCast;
            current_broadcast = layoutdata;
            next_broadcast = broadCastData?.NextBroadCast;
            String currentTime = getFormattedCurrentDateTime();
            int startTimeDifference =
                timeDifference(current_broadcast!.startDateTime!, currentTime) +
                    (systemToServerTimeDifference ?? 0);
            int endTimeDifference =
                timeDifference(current_broadcast!.endDateTime!, currentTime) +
                    (systemToServerTimeDifference ?? 0);

            if (currentBroadcastInString !=
                    broadCastData?.currentBroadCast?.stringData ||
                nextBroadcastInString !=
                    broadCastData!.NextBroadCast?.stringData) {
              if (HARDCODEPLATFORM != 'WEB') {
                // add(MediaLoadingEvent());
                // await preloadContents(current_broadcast!)
                //     .timeout(Duration(seconds: endTimeDifference));
                //IT CHECK ALL FILES ARE CACHED IF ANY MISSING THEN IT RETURN FALSE
                bool isCached = await allCached(current_broadcast!);
                print("cachdeeeeeeeeeeeeed = $isCached");

                lastDownloadingFile?.cancel();
                add(DownloadFeedbackEvent(
                    progress: 50, isVisible: false, markerText: ""));

                if (isCached) {
                  await preloadContents(current_broadcast!);
                } else {
                  try {
                    add(MediaLoadingEvent());
                    await preloadContents(current_broadcast!)
                        .timeout(Duration(seconds: endTimeDifference));
                  } on TimeoutException {
                    log("Preloading timed out!");
                    add(FetchApi(screenCode: event.screenCode));
                  }
                }
                // try {
                //   add(MediaLoadingEvent());
                //   await preloadContents(current_broadcast!)
                //       .timeout(Duration(seconds: endTimeDifference));
                // } on TimeoutException {
                //   log("Preloading timed out!");
                //   add(FetchApi(screenCode: event.screenCode));
                // }

                String stringResponce =
                    jsonEncode(broadCastData!.toJsonBroadCastModel());

                print("STRING RESPONCE FOR CACHING IS >>>>>>>>>>" +
                    stringResponce);

                // FOR OFFLINE ACCESSIBILITY
                saveResponce(stringResponce);

                if (next_broadcast != null) {
                  preloadContents(next_broadcast!);
                }
              }

              // IF YOU WANT LOADING SCREEN ON EACH TRANSITION PLEASE UNCOMMENT IT

              //  add(TrasnsitionEvent());
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
        } else if (!result && isFirstLoad) {
          // screen_code = event.screenCode;
          handlestatewithoutInternet(event.screenCode);
        }

        isFirstLoad = false;
      }
      if (event is MediaLoadingEvent) {
        if (HARDCODEPLATFORM != "WEB") {
          //  emit(MediaLoadingState());
        }
      }
      if (event is TakeScreenShotEvent) {
        emit(TakeScreenState(screenshoot_id: event.screenshoot_id));
      }
      if (event is UploadScreenShootEvent) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String secretkey = await prefs.getString('secretKey')!;
        String? signedurl =
            await LayoutRepository().generateSignedUrlForAws(secretkey);
        print("signed url = " + signedurl!);
        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/image.png').create();
        file.writeAsBytesSync(event.capturedimage);

        await LayoutRepository().uploadFileToPresignedUrl(file, signedurl);

        String cleanUrl = signedurl.split('?')[0];

        await LayoutRepository()
            .updateScreenShotToDb(screen_code!, cleanUrl, secretkey,event.screenshoot_id);

        print("SCREEN SHOOT UPLOAD SUCEESFULLY");
        print(cleanUrl);
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
        // if (event.countdown <= 3) {
        //   emit(TrasitionState());
        // } else if (event.countdown > 5) {
        //   emit(TrasitionState());
        //   await Future.delayed(Duration(seconds: 2));
        //   int countDown = event.countdown - 2;
        //   emit(DefaultScreen(countdown: countDown));
        // } else {
        //   emit(DefaultScreen(countdown: event.countdown));
        // }
        // emit(DefaultScreen(countdown: event.countdown));
        if (event.countdown > 604800) {
          emit(NoBroadcastState());
          return;
        }
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
        emit(NoBroadcastState());
      }
      if (event is DisplayBroadcastEvent) {
        emit(DisplayLayout(layoutdata: event.layoutData));
      }
      if (event is LogoutEvent) {
        print("logoutttttttttttttttttttt");
        clearData();
        currentBroadcastInString = "";
        isFirstLoad = true;
        globalConnection.close();
        await streamSubscription.cancel();
        emit(LogoutState());
      }
      if (event is TrasnsitionEvent) {
        emit(TrasitionState());
      }
      if (event is OfflineEvent) {
        emit(OfflineState());
      }
      if (event is DownloadFeedbackEvent) {
        print("DownloadFeedbackEvent");
        emit(DownloadProgressState(
            progress: event.progress,
            isVisible: event.isVisible,
            markerText: event.markerText));
      }

      if (event is currentBroadCastEnds) {
        print("CURRENT BROADCAST ENDS");
        if (next_broadcast == null) {
          add(NoBroadCastEvent());
        } else {
          next_broadcast!.currentDatetime = event.current_datetime;
          manageBroadcast(next_broadcast!);
        }
        bool connectionresult = await InternetConnection().hasInternetAccess;
        if (connectionresult) {
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
      }
    });
  }

  Future saveTimedifference(String servertime) async {
    DateTime now = DateTime.now();
    DateTime serverDateTime = DateTime.parse(servertime);

    Duration difference = now.difference(serverDateTime);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('time_difference', difference.inSeconds);

    // To demonstrate, we'll print the difference
    print("R: ${difference.inSeconds}");
  }

  Future<int> gettimedifference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return (await prefs.getInt('time_difference') ?? 0);
  }

  //FOR OFFLINE ACCESSIBILITY //
  void saveResponce(String responce) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_responce', responce);
  }

  String getFormattedCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return formatter.format(now);
  }

  void handlestatewithoutInternet(String screencode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? cache_responce = prefs.getString('cached_responce');

    if (cache_responce == null) {
      print("cache responce is empty");
      add(OfflineEvent());
    } else {
      print("CACHE SAVED MESSAGE");
      print(cache_responce);
      BroadCastModel? broadCastData =
          await LayoutRepository().fetchDataFromStorage(cache_responce);

      int difference = await gettimedifference();

      DateTime now = DateTime.now();
      now.subtract(Duration(seconds: difference));

      broadCastData!.currentBroadCast!.currentDatetime = now.toString();

      if (broadCastData?.currentBroadCast == null) {
        RELOAD_FLAG_COUNT++;
        print("no dataaaaaaaaa");
        add(NoBroadCastEvent());
      } else {
        print("there is data");
        LayoutData? layoutdata = broadCastData?.currentBroadCast;
        current_broadcast = layoutdata;
        next_broadcast = broadCastData?.NextBroadCast;
        String currentTime = getFormattedCurrentDateTime();

        if (currentBroadcastInString !=
                broadCastData?.currentBroadCast?.stringData ||
            nextBroadcastInString != broadCastData!.NextBroadCast?.stringData) {
          if (HARDCODEPLATFORM != 'WEB') {
            add(MediaLoadingEvent());
            int end_difference =
                timeDifference(current_broadcast!.endDateTime!, currentTime) +
                    (systemToServerTimeDifference ?? 0);
            if (next_broadcast != null) {
              preloadContents(next_broadcast!);
            }
          }
          add(TrasnsitionEvent());
          await Future.delayed(Duration(seconds: 1));

          RELOAD_FLAG_COUNT++;
          currentBroadcastInString =
              broadCastData!.currentBroadCast?.stringData!;
          nextBroadcastInString = broadCastData.NextBroadCast?.stringData!;

          lastUpdateTime = layoutdata!.lastUpdatedAt!;
          manageBroadcast(current_broadcast!);
        }
      }
    }
  }

  Future<bool> havePath(LayoutData layoutdata) async {
    bool path = true;
    for (var zoneData in layoutdata.zoneData!) {
      for (var content in zoneData.compositionModels) {
        print(content.fileFormat);
        print("path = ${content.localstoragepath}");
        if (content.localstoragepath == null ||
            content.localstoragepath.isEmpty) {
          // add(NoBroadCastEvent());
          if (content.contentType != 'app') {
            // if it does contain any content that is not able to play
            path = false;
            break;
          }
        }
      }
      if (!path) {
        break;
      }
    }
    return path;
  }

  void manageBroadcast(LayoutData layoutdata) async {
    print("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");
    log("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");

    bool online = await InternetConnection().hasInternetAccess;
    if (!online) {
      bool path = await havePath(layoutdata);
      if (!path) {
        print("there is no pathhhhhhhhhhhhhhhh");
        add(NoBroadCastEvent());
        return;
      }
    }

    String currentTime = getFormattedCurrentDateTime();
    print("current");
    print(currentTime);

    int start_difference =
        timeDifference(layoutdata.startDateTime!, currentTime) +
            (systemToServerTimeDifference ?? 0);

    int end_difference = 0;
    if (start_difference < 0) {
      end_difference = timeDifference(layoutdata.endDateTime!, currentTime) +
          (systemToServerTimeDifference ?? 0);
    } else {
      end_difference =
          timeDifference(layoutdata.endDateTime!, layoutdata.startDateTime!) -
              (systemToServerTimeDifference ?? 0);
    }
    print("END TIME =  ${layoutdata.startDateTime}");
    print("END TIME =  ${layoutdata.endDateTime}");
    print("START TIME DIFFERENCEEEEEEEEEEEEEE  $start_difference");
    print("END TIME DIFFERENCEEEEEEEEEEEEEE  $end_difference");

    int current_reload_flag_count = RELOAD_FLAG_COUNT;

    if (start_difference > 0) {
      log("Countdown started");
      add(CountDownEvent(countdown: start_difference));

      await Future.delayed(Duration(seconds: start_difference), () {
        if (current_reload_flag_count == RELOAD_FLAG_COUNT) {
          add(DisplayBroadcastEvent(layoutData: layoutdata));
          log_start_broadcast(layoutdata.id!);
        }
      });

      await Future.delayed(Duration(seconds: end_difference), () {
        print("broadcast ended");
        if (current_reload_flag_count == RELOAD_FLAG_COUNT) {
          print("new event added1");
          add(currentBroadCastEnds(current_datetime: layoutdata.endDateTime!));
          log_end_broadcast(layoutdata.id!);
        }
      });
    } else if (start_difference <= 0 && end_difference > 0) {
      print("new event added2");
      add(DisplayBroadcastEvent(layoutData: layoutdata));
      log_start_broadcast(layoutdata.id!);
      await Future.delayed(Duration(seconds: end_difference), () {
        if (current_reload_flag_count == RELOAD_FLAG_COUNT) {
          add(currentBroadCastEnds(current_datetime: layoutdata.endDateTime!));
          log_end_broadcast(layoutdata.id!);
        }
      });
    } else if (end_difference <= 0) {
      add(NoBroadCastEvent());
    }
  }

  Future<bool> allCached(LayoutData broadcastData) async {
    print("check cachinggg");
    bool isAllCached = true;
    var cachedFile;

    final cacheManager = DefaultCacheManager();
    for (var zoneData in broadcastData.zoneData!) {
      for (var content in zoneData.compositionModels) {
        // var file = await DefaultCacheManager().getSingleFile(BASEURL + content.fileUrl);
        cachedFile =
            await cacheManager.getFileFromCache(BASEURLMEDIA + content.fileUrl);

        if (cachedFile == null) {
          print("ONE FILE IS NOT CACHED");
          print(BASEURLMEDIA + content.fileUrl);
          isAllCached = false;
          break;
        }
      }
      if (!isAllCached) {
        print("ALL FILES ARE NOT CACHED ALREADY");
        break;
      }
    }
    print("ALL FILES ARE CACHED ALREADY");
    return isAllCached;
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
      print("screen shot id");
      print(jsonresponce);
      if (lastUpdateTime != jsonresponce['updated_at']) {
        if (jsonresponce["status"] == "take screenshot") {
          int id = jsonresponce["screenshot_id"];
          add(TakeScreenShotEvent(screenshoot_id: id));
        } else {
          log("Time changeddddddddddddddddddddddddddddddddddddddddddd");
          lastUpdateTime = jsonresponce['updated_at'];
          add(FetchApi(screenCode: screencode));
        }
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
              '{"screen_code" : $formattedScreenCode, "client_type" : "device","is_registered":"true"}');
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
              '{"screen_code" : $formattedScreenCode, "client_type" : "device","is_registered":"true"}');
          sync_data_to_server_when_online();
          add(FetchApi(screenCode: screencode));
          addToServer();
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

  // void preloadContents(LayoutData broadcastData) async {
  //   print("cacheiggg");
  //   broadcastData.zoneData!.forEach((zonedata) {
  //     zonedata.compositionModels.forEach((content) {
  //       DefaultCacheManager().getSingleFile(BASEURL + content.fileUrl);
  //     });
  //   });
  // }

// void activateDownloadcontroller(){

// downloadController.stream.listen((event) {
//     preloadContents(broadcastData)
//   });

// }

  Future preloadContents(LayoutData broadcastData) async {
    int totalFiles = 0;
    for (var zoneData in broadcastData.zoneData!) {
      for (var content in zoneData.compositionModels) {
        if (content.fileUrl != '' && content.contentType == 'media') {
          totalFiles++;
        }
      }
    }

    int currentCount = 0;

    print("cacheiggg");

    String currentTime = getFormattedCurrentDateTime();
    int startTimeDifference =
        timeDifference(current_broadcast!.startDateTime!, currentTime) +
            (systemToServerTimeDifference ?? 0);

    int quick_broadcast_count = 0;

    print("TIME DIFFERENCE");
    print(startTimeDifference);

    if (startTimeDifference <= 10) {
      QUICK_BROADCAST_COUNT = QUICK_BROADCAST_COUNT + 1;
      quick_broadcast_count = QUICK_BROADCAST_COUNT;
      print("QUICK BROADCAST ADDED");
    }

    for (var zoneData in broadcastData.zoneData!) {
      for (var content in zoneData.compositionModels) {
        if (content.fileUrl != '' && content.contentType == 'media') {
          currentCount++;

          if (quick_broadcast_count == QUICK_BROADCAST_COUNT) {
            lastDownloadingFile = DefaultCacheManager()
                .getFileStream(content.fileUrl, withProgress: true)
                .listen((response) {
              if (response is DownloadProgress) {
                double percent =
                    (response.downloaded / response.totalSize!.toInt()) * 100;
                // print("percent $percent");

                if (lastdownloadprogress != percent.toInt()) {
                  lastdownloadprogress = percent.toInt();
                  // print("add DownloadfeedbackEvent");
                  if (percent.toInt() < 99) {
                    add(DownloadFeedbackEvent(
                        progress: lastdownloadprogress,
                        isVisible: true,
                        markerText:
                            "Downloading file $currentCount/$totalFiles"));
                  } else {
                    print("else block of 100 percent");
                    lastdownloadprogress = 0;
                    add(DownloadFeedbackEvent(
                        progress: 50,
                        isVisible: false,
                        markerText: "${currentCount / totalFiles}"));
                  }
                }

                print(
                    'Downloading: ${response.downloaded}/${response.totalSize}');
              } else if (response is FileInfo) {
                print('File ready: ${response.file.path}');
              }
            });
          }

          var file = await DefaultCacheManager()
              .getSingleFile(BASEURLMEDIA + content.fileUrl);
          content.localstoragepath = file.path;

          print("PRELOAD CONTENTS CALLED");
          print("CONTENT PATH ==" + file.path);
        }
      }
      ;
    }
    ;
  }
}
