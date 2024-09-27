// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:digitalsignange/Costants.dart';

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

  LayoutblocBloc() : super(LayoutblocInitial()) {
    on<LayoutblocEvent>((event, emit) async {
      if (event is FetchApi) {
        LayoutData? layoutdata =
            await LayoutRepository().fetchData(event.screenCode);
        if (isFirstLoad) {
          connect(event.screenCode);
          isFirstLoad = false;
        }
        if (layoutdata == null) {
          emit(DefaultScreen());
          print("emitting default");
          return;
        }
        print("update = ${layoutdata!.lastUpdatedAt}");
        lastUpdateTime = layoutdata.lastUpdatedAt!;

        int start_difference = timeDifference(
            layoutdata!.startDateTime!, layoutdata.currentDatetime!);
        int end_difference = timeDifference(
            layoutdata!.endDateTime!, layoutdata.currentDatetime!);

        if (start_difference > 0) {
          // if start time greater than current time
          //emit default screen and schedule start screen
          emit(DefaultScreen());

          scheduleEvent(layoutdata.startDateTime!, layoutdata.endDateTime!,
              layoutdata.currentDatetime!, layoutdata, event.screenCode);
        } else if (end_difference < 0) {
          emit(DefaultScreen());
        } else {
          // emit(DisplayLayout(layoutdata: layoutdata));
          scheduleEvent(layoutdata.startDateTime!, layoutdata.endDateTime!,
              layoutdata.currentDatetime!, layoutdata, event.screenCode);
          emit(DisplayLayout(layoutdata: layoutdata));
        }
      }

      if (event is StartEvent) {
        emit(DisplayLayout(layoutdata: event.layoutdata));
      }
      if (event is EndEvent) {
        emit(DefaultScreen());
      }
      if (event is visibleButton) {
        emit(DisplayButton(isvisible: event.isvisible));
      }
      // if (event is ShrinkView) {
      //   emit(DisplayButton(isvisible: event.isvisible));
      // }
    });
  }

  void scheduleEvent(String startTime, String endTime, String curretTime,
      LayoutData layoutdata, String screenCode) async {
    int start_difference = timeDifference(startTime, curretTime);
    int end_Difference = timeDifference(endTime, startTime);

    print("inside schedule event");
    print("startDiff = $start_difference");
    print("endDiff = $end_Difference");

    if (start_difference > 0) {
      await Future.delayed(Duration(seconds: start_difference), () {
        add(StartEvent(layoutdata: layoutdata));
      });
      await Future.delayed(Duration(seconds: end_Difference), () {
        add(EndEvent());
      });
      await Future.delayed(Duration(seconds: 5), () {});
      add(FetchApi(screenCode: screenCode));
    } else {
      end_Difference = timeDifference(endTime, curretTime);
      await Future.delayed(Duration(seconds: end_Difference), () {
        add(EndEvent());
      });

      await Future.delayed(Duration(seconds: 5), () {});
      add(FetchApi(screenCode: screenCode));
    }
  }

  void connect(String screencode) async {
    final socket = WebSocket(Uri.parse(SOCKET_ADDRESS));
    socket.messages.listen((message) {
      print("socket message = $message");
      var jsonresponce = jsonDecode(message);
      print("socket response = $jsonresponce");
      print("socket updated time = ${jsonresponce['updated_at']}");
      if (lastUpdateTime != jsonresponce['updated_at']) {
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
          socket.send('{"screen_code" : $formattedScreenCode}');
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
          socket.send('{"screen_code" : $formattedScreenCode}');
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
}
