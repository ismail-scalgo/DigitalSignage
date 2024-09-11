import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/REPOSITORIES/LayoutRepo.dart';
import 'package:digitalsignange/MODELS/ContentModel.dart';
import 'package:digitalsignange/MODELS/MediaDetailModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/MODELS/ZoneModel.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:queue/queue.dart';
import 'package:web_socket_client/web_socket_client.dart';

part 'layoutbloc_event.dart';
part 'layoutbloc_state.dart';

class LayoutblocBloc extends Bloc<LayoutblocEvent, LayoutblocState> {
  bool isLocked = false;
  bool isFirstLoad = true;

  LayoutblocBloc() : super(LayoutblocInitial()) {
    on<LayoutblocEvent>((event, emit) async {
      if (event is FetchApi) {
        Map<int, MediaDetails> lastUpdatedData = {};
        log("fetch api called");
        if (isFirstLoad) {
          isFirstLoad = false;
          connect();
        }
        final Data? responseData;
        Map<int, MediaDetails> contentsMap = {};
        final LayoutRepository apiRepo = LayoutRepository();
        responseData = await apiRepo.fetchResponse();
        int count = 1;
        for (var zones in responseData!.zoneData) {
          List<Contents> contentsList = zones.contents;
          MediaDetails obj = MediaDetails(
            id: count,
            height: zones.height,
            width: zones.width,
            contentsList: zones.contents,
            currentDurationCount: 0,
            currentMediaPosition: 0,
          );
          contentsMap[count] = obj;
          count++;
        }
        lastUpdatedData = contentsMap;
        responseData.currentTime = "2024-09-03T10:17:00";
        int start_difference =
            timeDifference(responseData.startTime, responseData.currentTime);
        if (start_difference > 0) {
          emit(DefaultScreen());
        } else {
          emit(DisplayLayout(mediaMap: contentsMap));
        }
        // int end_Difference = timeDifference(endTime);
        scheduleEvent(responseData.startTime, responseData.endTime,
            responseData.currentTime, contentsMap);
        print("start time = ${responseData.startTime}");
        print("end time = ${responseData.endTime}");
      }
      if (event is StartEvent) {
        emit(DisplayLayout(mediaMap: event.contentsMap));
      }
      if (event is EndEvent) {
        emit(DefaultScreen());
      }
    });
  }
  void scheduleEvent(String startTime, String endTime, String curretTime,
      Map<int, MediaDetails> contentsMap) async {
    int start_difference = timeDifference(startTime, curretTime);
    int end_Difference = timeDifference(endTime, curretTime);
    if (start_difference > 0) {
      await Future.delayed(Duration(seconds: start_difference), () {
        add(StartEvent(contentsMap: contentsMap));
      });
      await Future.delayed(Duration(seconds: end_Difference), () {
        add(EndEvent());
      });
    } else {
      await Future.delayed(Duration(seconds: end_Difference), () {
        add(EndEvent());
      });
    }
  }

  void connect() async {
    final socket = WebSocket(Uri.parse('ws://192.168.0.84:8765'));
    socket.messages.listen((message) {
      log("fetch  $message");
      if (message == "datachange") {
        add(FetchApi());
      }
    });
    socket.send('ping');
  }
}

int timeDifference(String time, String curretTime) {
  DateTime givenDateTime = DateTime.parse(time);
  DateTime now = DateTime.parse(curretTime);
  Duration difference = givenDateTime.difference(now);
  return difference.inSeconds;
}
