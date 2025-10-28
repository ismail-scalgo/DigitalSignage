// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_DebugPrint, prefer_interpolation_to_compose_strings, prefer_const_constructors, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:player/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:player/CONTENTLOG.dart';
import 'package:player/Costants.dart';
import 'package:player/LOGS.dart';
import 'package:player/MODELS/BroadCastModel.dart';
import 'package:player/MODELS/XCompositionModel.dart';
import 'package:player/REPOSITORIES/XcompositionRepository.dart';
import 'package:player/UI/NoInternetScreen.dart';

import 'package:player/UI/Utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player/Utils.dart';
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

  bool isScoketConnectedForFirstTime = false;
  bool isSocketConnectTimerSttarted = false;

  StreamSubscription<FileResponse>? lastDownloadingFile;

  int? systemToServerTimeDifference;

  StreamSubscription<InternetStatus>? _internetListener;
  WebSocket? _socket;
  bool _isSocketManuallyClosed = false;
  bool _hasEverConnected = false;
  Timer? _reconnectDelay;

  String _currentSocketState = "Disconneted";
  bool _is_socket_first_connected = false;

  // final downloadController = StreamController<LayoutData>();

  int lastdownloadprogress = 0;
  //if any time it is reloaded then any timer scheduled will not work
  //it will check usig reload variable
  int RELOAD_FLAG_COUNT = 0;

  int QUICK_BROADCAST_COUNT = 0;

  LayoutblocBloc() : super(LayoutblocInitial()) {
    DebugPrint("LAYOUT BLOC CALLEDDDDDDDDD");
    log_of_start_stop();

    on<LayoutblocEvent>((event, emit) async {
      DebugPrint("LAYOU BLOCK EVENT");
      DebugPrint(event);
      if (event is FetchApi) {
        log("fetch api event called");
        DebugPrint("fetch api event called");
        screen_code = event.screenCode!;

        if (isFirstLoad) {
          await init();
          connect(event.screenCode);
        }
        bool result = await InternetConnection().hasInternetAccess;

        if (result) {
          screen_code = event.screenCode;
          BroadCastModel? broadCastData = await LayoutRepository().newFetchData(
            event.screenCode,
          );

          refactorBroadcastModelForQuickSchedule(broadCastData);

          if (broadCastData?.message == "Screen Code doesn't exist") {
            add(LogoutEvent());
          }
          if (broadCastData?.currentBroadCast == null) {
            RELOAD_FLAG_COUNT++;

            emit(NoBroadcastState());
            sendLiveDataToSocket(false);
          } else {
            DebugPrint("there is data");
            if (broadCastData?.currentBroadCast != null) {
              await saveTimedifference(
                (broadCastData?.currentBroadCast!.currentDatetime)!,
              );
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
                DebugPrint("cachdeeeeeeeeeeeeed = $isCached");

                lastDownloadingFile?.cancel();
                add(
                  DownloadFeedbackEvent(
                    progress: 50,
                    isVisible: false,
                    markerText: "",
                  ),
                );

                if (isCached) {
                  await preloadContents(current_broadcast!);
                } else {
                  try {
                    add(MediaLoadingEvent());
                    await preloadContents(
                      current_broadcast!,
                    ).timeout(Duration(seconds: endTimeDifference));

                    HAS_ANY_OFFLINE_UNSPPOTED_MEDIA = hasAnyNonOfflineContents(
                      current_broadcast!,
                    );
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

                String stringResponce = jsonEncode(
                  broadCastData!.toJsonBroadCastModel(),
                );

                DebugPrint(
                  "STRING RESPONCE FOR CACHING IS >>>>>>>>>>" + stringResponce,
                );

                // FOR OFFLINE ACCESSIBILITY
                saveResponce(stringResponce);

                if (next_broadcast != null) {
                  preloadContents(next_broadcast!);
                }
              }

              // IF YOU WANT LOADING SCREEN ON EACH TRANSITION PLEASE UNCOMMENT IT

              //  add(TrasnsitionEvent());
              await Future.delayed(Duration(seconds: 1));
              DebugPrint("data changingggggggggg");
              RELOAD_FLAG_COUNT++;
              currentBroadcastInString =
                  broadCastData!.currentBroadCast?.stringData!;
              nextBroadcastInString = broadCastData.NextBroadCast?.stringData!;
              DebugPrint("update = ${layoutdata!.lastUpdatedAt}");
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

      if (event is NoBroadcastWithoutInternetEvent) {
        emit(NOBroadcastWithoutInternetState());
      }
      if (event is UploadScreenShootEvent) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String secretkey = await prefs.getString('secretKey')!;
        String? signedurl = await LayoutRepository().generateSignedUrlForAws(
          secretkey,
        );
        DebugPrint("signed url = " + signedurl!);
        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/image.png').create();
        file.writeAsBytesSync(event.capturedimage);

        await LayoutRepository().uploadFileToPresignedUrl(file, signedurl);

        String cleanUrl = signedurl.split('?')[0];

        await LayoutRepository().updateScreenShotToDb(
          screen_code!,
          cleanUrl,
          secretkey,
          event.screenshoot_id,
        );

        DebugPrint("SCREEN SHOOT UPLOAD SUCEESFULLY");
        DebugPrint(cleanUrl);
      }
      if (event is StartEvent) {
        DebugPrint("START_EVENT");
        emit(DisplayLayout(layoutdata: event.layoutdata));
      }
      if (event is EndEvent) {
        emit(NoBroadcastState());
        sendLiveDataToSocket(false);
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
          sendLiveDataToSocket(false);
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
        sendLiveDataToSocket(false);
      }
      if (event is DisplayBroadcastEvent) {
        emit(DisplayLayout(layoutdata: event.layoutData));

        sendLiveDataToSocket(true);
      }
      if (event is LogoutEvent) {
        DebugPrint("logoutttttttttttttttttttt");
        await clearData();
        currentBroadcastInString = "";
        isFirstLoad = true;
        closeSocket();
        // globalConnection.close();
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
        DebugPrint("DownloadFeedbackEvent");
        emit(
          DownloadProgressState(
            progress: event.progress,
            isVisible: event.isVisible,
            markerText: event.markerText,
          ),
        );
      }

      if (event is currentBroadCastEnds) {
        DebugPrint("CURRENT BROADCAST ENDS");
        if (next_broadcast == null) {
          add(NoBroadCastEvent());
        } else {
          next_broadcast!.currentDatetime = event.current_datetime;
          manageBroadcast(next_broadcast!);
        }
        bool connectionresult = await InternetConnection().hasInternetAccess;
        if (connectionresult) {
          await Future.delayed(Duration(seconds: 2));
          BroadCastModel? broadCastData = await LayoutRepository().newFetchData(
            screen_code!,
          );
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
    // DateTime serverDateTime = DateTime.parse(servertime);

    DateTime serverDateTime = now;
    Duration difference = now.difference(serverDateTime);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('time_difference', difference.inSeconds);

    // To demonstrate, we'll DebugPrint the difference
    DebugPrint("R: ${difference.inSeconds}");
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
    DebugPrint("handle without internet");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? cache_responce = prefs.getString('cached_responce');

    if (cache_responce == null) {
      DebugPrint("cache responce is empty");
      add(OfflineEvent());
    } else {
      DebugPrint("CACHE SAVED MESSAGE");
      DebugPrint(cache_responce);
      BroadCastModel? broadCastData = await LayoutRepository()
          .fetchDataFromStorage(cache_responce);

      int difference = await gettimedifference();

      DateTime now = DateTime.now();
      now.subtract(Duration(seconds: difference));

      broadCastData!.currentBroadCast!.currentDatetime = now.toString();

      if (broadCastData?.currentBroadCast == null) {
        RELOAD_FLAG_COUNT++;
        DebugPrint("no dataaaaaaaaa");
        add(NoBroadcastWithoutInternetEvent());
      } else {
        bool isAllContentSupportOffline = hasAnyNonOfflineContents(
          broadCastData!.currentBroadCast!,
        );

        if (isAllContentSupportOffline) {
          DebugPrint("there is data");
          LayoutData? layoutdata = broadCastData?.currentBroadCast;
          current_broadcast = layoutdata;
          next_broadcast = broadCastData?.NextBroadCast;
          String currentTime = getFormattedCurrentDateTime();

          if (currentBroadcastInString !=
                  broadCastData?.currentBroadCast?.stringData ||
              nextBroadcastInString !=
                  broadCastData!.NextBroadCast?.stringData) {
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
        } else {
          add(NoBroadcastWithoutInternetEvent());
        }
      }
    }
  }

  void refactorBroadcastModelForQuickSchedule(BroadCastModel? broadcastdata) {
    if (broadcastdata != null) {
      if (broadcastdata.currentBroadCast != null) {
        if (broadcastdata.currentBroadCast!.broadcast_type == "QUICK") {
          broadcastdata.currentBroadCast!.startDateTime =
              DateTime.now().toString();

          DebugPrint("refactored current time");
          DebugPrint(DateTime.now().toString());
          if (broadcastdata.currentBroadCast!.endDateTime == "") {
            broadcastdata.currentBroadCast!.endDateTime =
                DateTime.now().add(Duration(days: 200)).toString();
          }
        }
      }
    }
  }

  Future<bool> havePath(LayoutData layoutdata) async {
    bool path = true;
    for (var zoneData in layoutdata.zoneData!) {
      for (var content in zoneData.compositionModels) {
        DebugPrint(content.fileFormat);
        DebugPrint("path = ${content.localstoragepath}");
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
    DebugPrint("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");
    log("MANAGE BROADCAST CALLLEEEEEEEEEEEDDDDDDDDDD");

    bool online = await InternetConnection().hasInternetAccess;
    if (!online) {
      bool path = await havePath(layoutdata);
      if (!path) {
        DebugPrint("there is no pathhhhhhhhhhhhhhhh");
        add(NoBroadCastEvent());
        return;
      }
    }

    String currentTime = getFormattedCurrentDateTime();
    DebugPrint("current");
    DebugPrint(currentTime);

    int start_difference =
        timeDifference(layoutdata.startDateTime!, currentTime) +
        (systemToServerTimeDifference ?? 0);

    int end_difference = 0;
    if (start_difference < 0) {
      end_difference =
          timeDifference(layoutdata.endDateTime!, currentTime) +
          (systemToServerTimeDifference ?? 0);
    } else {
      end_difference =
          timeDifference(layoutdata.endDateTime!, layoutdata.startDateTime!) -
          (systemToServerTimeDifference ?? 0);
    }
    DebugPrint("END TIME =  ${layoutdata.startDateTime}");
    DebugPrint("END TIME =  ${layoutdata.endDateTime}");
    DebugPrint("START TIME DIFFERENCEEEEEEEEEEEEEE  $start_difference");
    DebugPrint("END TIME DIFFERENCEEEEEEEEEEEEEE  $end_difference");

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
        DebugPrint("broadcast ended");
        if (current_reload_flag_count == RELOAD_FLAG_COUNT) {
          DebugPrint("new event added1");
          add(currentBroadCastEnds(current_datetime: layoutdata.endDateTime!));
          log_end_broadcast(layoutdata.id!);
        }
      });
    } else if (start_difference <= 0 && end_difference > 0) {
      DebugPrint("new event added2");
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
    DebugPrint("check cachinggg");
    bool isAllCached = true;
    var cachedFile;

    final cacheManager = DefaultCacheManager();
    for (var zoneData in broadcastData.zoneData!) {
      for (var content in zoneData.compositionModels) {
        // var file = await DefaultCacheManager().getSingleFile(BASEURL + content.fileUrl);
        cachedFile = await cacheManager.getFileFromCache(
          BASEURLMEDIA + content.fileUrl,
        );

        if (cachedFile == null) {
          DebugPrint("ONE FILE IS NOT CACHED");
          DebugPrint(BASEURLMEDIA + content.fileUrl);
          isAllCached = false;
          break;
        }
      }
      if (!isAllCached) {
        DebugPrint("ALL FILES ARE NOT CACHED ALREADY");
        break;
      }
    }
    DebugPrint("ALL FILES ARE CACHED ALREADY");
    return isAllCached;
  }

  void connect(String screenCode) async {
    DebugPrint("🔌 Attempting WebSocket connect...");

    _isSocketManuallyClosed = false;

    // If already connected or connecting, skip
    if (_socket != null) {
      final state = _socket!.connection.state;
      if (state is Connected || state is Connecting) {
        DebugPrint("🟢 Socket already active, skipping reconnect");
        return;
      }
    }

    try {
      _socket = WebSocket(
        Uri.parse(SOCKET_ADDRESS),
        backoff: const ConstantBackoff(Duration(seconds: 5)), // automatic retry
      );

      globalConnection = _socket!;

      // 🔹 Handle incoming messages
      _socket!.messages.listen((message) async {
        try {
          final data = jsonDecode(message);
          DebugPrint("📩 Socket message: $data");

          if (data["status"] == "take screenshot") {
            add(TakeScreenShotEvent(screenshoot_id: data["screenshot_id"]));
          } else if (data["status"] == "plan expired") {
            add(NoBroadCastEvent());
          } else if (lastUpdateTime != data["updated_at"]) {
            lastUpdateTime = data["updated_at"];
            add(FetchApi(screenCode: screenCode));
          }
        } catch (e) {
          DebugPrint("⚠️ Socket message parse error: $e");
        }
      });

      // 🔹 Handle connection lifecycle
      _socket!.connection.listen((state) {
        if (state is Connected) {
          DebugPrint("🟢 Connected to WebSocket");
          _hasEverConnected = true;
          _is_socket_first_connected = true;

          // Register screen
          final json = jsonEncode({
            "screen_code": screenCode,
            "client_type": "device",
            "is_registered": "true",
          });
          _socket!.send(json);
          sendLiveDataToSocket(true);
          DebugPrint("current_socket_state");
          DebugPrint(_currentSocketState);

          if (_currentSocketState == "Disconnected" ||
              !_is_socket_first_connected) {
            add(FetchApi(screenCode: screenCode));
          }
          _currentSocketState = "Connected";
        }

        if (state is Disconnected && !_isSocketManuallyClosed) {
          DebugPrint("🔴 Disconnected. Waiting for internet to return...");
          add(FetchApi(screenCode: screenCode));
        }

        if (state is Reconnected) {
          DebugPrint("🟡 Reconnected — re-registering screen...");
          final json = jsonEncode({
            "screen_code": screenCode,
            "client_type": "device",
            "is_registered": "true",
          });
          _socket!.send(json);
        }
      });

      // 🔹 Watch internet connectivity
      _internetListener ??= InternetConnection().onStatusChange.listen((
        status,
      ) async {
        if (status == InternetStatus.connected) {
          DebugPrint("🌐 Internet connected");

          if (!_isSocketManuallyClosed) {
            // debounce to prevent flapping reconnects
            _reconnectDelay?.cancel();
            _reconnectDelay = Timer(const Duration(seconds: 2), () async {
              DebugPrint("🔁 Forcing WebSocket reconnect after network recovery...");
              try {
                _socket?.close();
              } catch (_) {}
              _socket = null;
              connect(screenCode);
            });
          }
        } else {
          DebugPrint("🚫 Internet disconnected");

          _currentSocketState = "Disconnected";
          //add(OfflineEvent());
        }
      });
    } catch (e) {
      DebugPrint("❌ Failed to initialize WebSocket: $e");
    }
  }

  void closeSocket() {
    DebugPrint("🧹 Closing WebSocket and cleaning up listeners");
    _isSocketManuallyClosed = true;
    _internetListener?.cancel();
    _internetListener = null;
    _reconnectDelay?.cancel();
    _reconnectDelay = null;

    try {
      _socket?.close();
    } catch (_) {}
    _socket = null;
  }

  Future timerForSocketConnectionManagement() async {
    isSocketConnectTimerSttarted = true;
    await Future.delayed(Duration(seconds: 7));
    if (!isScoketConnectedForFirstTime) {
      if (!isScoketConnectedForFirstTime) {
        connect(screen_code!);
      }
    }
  }

  int timeDifference(String time, String curretTime) {
    DateTime givenDateTime = DateTime.parse(time);
    DateTime now = DateTime.parse(curretTime);
    Duration difference = givenDateTime.difference(now);
    return difference.inSeconds;
  }

  // void preloadContents(LayoutData broadcastData) async {
  //   DebugPrint("cacheiggg");
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

  void sendLiveDataToSocket(bool isLIve) {
    Map data = {
      "screen_code": screen_code,
      "client_type": "device",
      "is_live": isLIve ? "true" : "false",
    };
    String jsonString = jsonEncode(data);
    DebugPrint("LIVE_SOCKET_SENT");
    DebugPrint(jsonString);
    globalConnection.send(jsonString);
  }

  bool hasAnyNonOfflineContents(LayoutData broadcastData) {
    bool is_all_content_support_offline = false;

    for (var zoneData in broadcastData.zoneData!) {
      for (var content in zoneData.compositionModels) {
        if (!content.is_content_support_offline) {
          return false;
        }
        // if (content.fileFormat == ".html") {
        //   return false;
        // }
      }
    }

    return true;
  }

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

    DebugPrint("cacheiggg");

    String currentTime = getFormattedCurrentDateTime();
    int startTimeDifference =
        timeDifference(current_broadcast!.startDateTime!, currentTime) +
        (systemToServerTimeDifference ?? 0);

    int quick_broadcast_count = 0;

    DebugPrint("TIME DIFFERENCE");
    DebugPrint(startTimeDifference);

    if (startTimeDifference <= 10) {
      QUICK_BROADCAST_COUNT = QUICK_BROADCAST_COUNT + 1;
      quick_broadcast_count = QUICK_BROADCAST_COUNT;
      DebugPrint("QUICK BROADCAST ADDED");
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
                        (response.downloaded / response.totalSize!.toInt()) *
                        100;
                    // DebugPrint("percent $percent");

                    if (lastdownloadprogress != percent.toInt()) {
                      lastdownloadprogress = percent.toInt();
                      // DebugPrint("add DownloadfeedbackEvent");
                      if (percent.toInt() < 99) {
                        add(
                          DownloadFeedbackEvent(
                            progress: lastdownloadprogress,
                            isVisible: true,
                            markerText:
                                "Downloading file $currentCount/$totalFiles",
                          ),
                        );
                      } else {
                        DebugPrint("else block of 100 percent");
                        lastdownloadprogress = 0;
                        add(
                          DownloadFeedbackEvent(
                            progress: 50,
                            isVisible: false,
                            markerText: "${currentCount / totalFiles}",
                          ),
                        );
                      }
                    }

                    DebugPrint(
                      'Downloading: ${response.downloaded}/${response.totalSize}',
                    );
                  } else if (response is FileInfo) {
                    DebugPrint('File ready: ${response.file.path}');
                  }
                });
          }

          var file = await DefaultCacheManager().getSingleFile(
            BASEURLMEDIA + content.fileUrl,
          );
          content.localstoragepath = file.path;

          DebugPrint("PRELOAD CONTENTS CALLED");
          DebugPrint("CONTENT PATH ==" + file.path);
        }
      }
      ;
    }
    ;
  }
}
