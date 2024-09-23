import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';

import 'package:digitalsignange/MODELS/XCompositionModel.dart';
import 'package:digitalsignange/REPOSITORIES/XcompositionRepository.dart';

import 'package:meta/meta.dart';

import 'package:web_socket_client/web_socket_client.dart';

part 'layoutbloc_event.dart';
part 'layoutbloc_state.dart';

class LayoutblocBloc extends Bloc<LayoutblocEvent, LayoutblocState> {
  bool isLocked = false;
  bool isFirstLoad = true;

  LayoutblocBloc() : super(LayoutblocInitial()) {
    on<LayoutblocEvent>((event, emit) async {
      if (event is FetchApi) {
        LayoutData? layoutdata =
            await LayoutRepository().fetchData(event.screenCode);

        int start_difference = timeDifference(
            layoutdata!.startDateTime, layoutdata.currentDatetime);

        if (start_difference > 0) {
          // if start time greater than current time
          //emit default screen and schedule start screen
          emit(DefaultScreen());
          scheduleEvent(layoutdata.startDateTime, layoutdata.endDateTime,
              layoutdata.currentDatetime, layoutdata);
        } else {
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
      LayoutData layoutdata) async {
    int start_difference = timeDifference(startTime, curretTime);
    int end_Difference = timeDifference(endTime, curretTime);

    if (start_difference > 0) {
      await Future.delayed(Duration(seconds: start_difference), () {
        add(StartEvent(layoutdata: layoutdata));
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

  // void connect() async {
  //   final socket = WebSocket(Uri.parse('ws://192.168.0.84:8765'));
  //   socket.messages.listen((message) {
  //     log("fetch  $message");
  //     if (message == "datachange") {
  //       add(FetchApi());
  //     }
  //   });
  //   socket.send('ping');
  // }
}

int timeDifference(String time, String curretTime) {
  DateTime givenDateTime = DateTime.parse(time);
  DateTime now = DateTime.parse(curretTime);
  Duration difference = givenDateTime.difference(now);
  return difference.inSeconds;
}
