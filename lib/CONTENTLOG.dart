import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:player/REPOSITORIES/ContentLogRepo.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:player/Utils.dart';

late Box buffer_box;
late Box recorded_box;
late Box last_saved_time_box;
late SharedPreferences prefs;
String? screenCode = prefs.getString('NewScreenCode');
StreamController controller = StreamController.broadcast();
Stream stream = controller.stream;

late StreamSubscription streamSubscription;
String CONTENT_NAME_KEY = "content_name";
String CONTENT_DURATION_KEY = "content_duration";
String CONTENT_COUNT_KEY = "content_count";
String START_TIME_KEY = "start_time";
String IS_COMPLETED_KEY = "is_completed";
String BROADCAST_START_TIME_KEY = "broadcast_start_datetime";
String BROADCAST_END_TIME_KEY = "broadcast_end_datetime";
DateTime LAST_SAVED_TIME = DateTime.now();
String LAST_SAVED_TIME_KEY = "last_saved_time_key";
bool IS_FIRST = true;

Future init() async {
  Directory appDocumentDir =
      await getApplicationDocumentsDirectory(); // Get the app's document directory
  Hive.init(appDocumentDir.path);
  prefs = await SharedPreferences.getInstance();

  buffer_box = await Hive.openBox("buffer_box");

  recorded_box = await Hive.openBox("recorded_box");

  last_saved_time_box = await Hive.openBox("last_saved_time");

  streamSubscription = stream.listen((value) async {
    DebugPrint("NEW STREAM ADDEDDDDDDDDDDDD");
    Map eventValue = value;
    if (eventValue['event'] == "content_add_event") {
      DebugPrint("oooooooooooook");
      addlogToBuffer(
          broadcast_id: eventValue['broadcast_id'],
          contentname: eventValue['content_name'],
          contentDuration: double.parse(eventValue['content_duration']),
          zoneno: eventValue['content_zone']);
    }
    if (eventValue['event'] == "broadcast_end_event") {
      addtoRecordFromBufferOnEnd();
    }
  });
}

void startPeriodicTime() {
  if (IS_FIRST) {
    Timer.periodic(Duration(seconds: 3), (time) {
      LAST_SAVED_TIME = DateTime.now();

      last_saved_time_box.put(LAST_SAVED_TIME_KEY, LAST_SAVED_TIME);
    });
  }

  IS_FIRST = false;
}

Future addlogToBuffer(
    {required String broadcast_id,
    required String contentname,
    required double contentDuration,
    required int zoneno}) async {
  DateTime dateTime = DateTime.now();

  var buffer_datas = buffer_box.keys;
  //IF ANY PENDING BROADCAST IN THE BUFFER
  DebugPrint("buffer length ========== ${buffer_datas}");
  if (buffer_datas.length > 0) {
    buffer_box.keys.forEach((key) async {
      if (key != broadcast_id) {
        await addtoRecordFromBufferOnEnd();
      }
    });
  }

  startPeriodicTime();
  //if it is first no logs created
  //create new
  if (!buffer_box.containsKey(broadcast_id)) {
    Map content_value = {
      BROADCAST_START_TIME_KEY: dateTime,
      zoneno: {
        CONTENT_NAME_KEY: contentname,
        CONTENT_DURATION_KEY: contentDuration,
        START_TIME_KEY: dateTime
      }
    };

    await buffer_box.put(broadcast_id, content_value);
  } else {
    DebugPrint("broadcast id already added");
    // current zone entry is new

    Map bufferdata = buffer_box.get(broadcast_id);

    if (bufferdata.containsKey(zoneno)) {
      DebugPrint("zone already addded");
      await addtoRecordOnNormalCondition(broadcast_id, bufferdata, zoneno);

      // ********* ADD TO RECORDED DATA ********** //
    }

    bufferdata[zoneno] = {
      CONTENT_NAME_KEY: contentname,
      CONTENT_DURATION_KEY: contentDuration,
      START_TIME_KEY: dateTime
    };

    await buffer_box.put(broadcast_id, bufferdata);
  }
  printValues();
}

Future addtoRecordOnNormalCondition(
    String broadcast_id, Map bufferdata, int zone) async {
  DebugPrint("zone = $zone");
  DebugPrint("buffer data = $bufferdata");
  String content_name = (buffer_box.get(broadcast_id))[zone][CONTENT_NAME_KEY];
  Map? recorded_data = recorded_box.get(broadcast_id);

  //VERY FIRST TIME WITHOUT CONTAINS BROADCAST ID
  if (!recorded_box.containsKey(broadcast_id)) {
    DebugPrint("VERY FIRST TIME WITHOUT CONTAINS BROADCAST ID");
    String content_name =
        (buffer_box.get(broadcast_id))[zone][CONTENT_NAME_KEY];
    double current_duration =
        (buffer_box.get(broadcast_id))[zone][CONTENT_DURATION_KEY];
    String broadcast_start_time =
        buffer_box.get(broadcast_id)[BROADCAST_START_TIME_KEY].toString();

    await recorded_box.put(broadcast_id, {
      content_name: {
        CONTENT_DURATION_KEY: current_duration,
        CONTENT_COUNT_KEY: 1
      },
      BROADCAST_START_TIME_KEY: broadcast_start_time,
      IS_COMPLETED_KEY: false
    });
  }

  //ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME
  else if (!recorded_data!.containsKey(content_name)) {
    DebugPrint("ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME");
    String content_name =
        (buffer_box.get(broadcast_id))[zone][CONTENT_NAME_KEY];
    double current_duration =
        (buffer_box.get(broadcast_id))[zone][CONTENT_DURATION_KEY];
    recorded_data[content_name] = {
      CONTENT_DURATION_KEY: current_duration,
      CONTENT_COUNT_KEY: 1
    };
    await recorded_box.put(broadcast_id, recorded_data);
  }
  //ALREADY BROADCAST ADDED ALSO CONTENT ADDED
  else if (recorded_data.containsKey(content_name)) {
    DebugPrint("ALREADY BROADCAST ADDED ALSO CONTENT ADDED");
    double past_duration =
        (recorded_data[content_name][CONTENT_DURATION_KEY]).toDouble();
    double current_duration =
        (buffer_box.get(broadcast_id))[zone][CONTENT_DURATION_KEY];
    double updated_duration = past_duration + current_duration;

    int past_count = (recorded_data[content_name][CONTENT_COUNT_KEY]);
    recorded_data[content_name] = {
      CONTENT_DURATION_KEY: updated_duration,
      CONTENT_COUNT_KEY: past_count + 1
    };
    await recorded_box.put(broadcast_id, recorded_data);
  }
}

Future addtoRecordFromBufferOnEnd() async {
  // check any logs on buffer and add to to recorded data

  var buffer_box_data = buffer_box.keys;

  // ITERATE ALL BROADCAST ID FROM BUFFER
  buffer_box_data.forEach((broadcast_id) async {
    DebugPrint("buffer_box_data keys = $broadcast_id");

    Map? bufferdata = buffer_box.get(broadcast_id);
    DateTime dateTimeNow = DateTime.now();
    Map? recorded_data = recorded_box.get(broadcast_id);
    DebugPrint("recorded_data = $recorded_data");
    if (bufferdata != null) {
      Map? recorded_data = recorded_box.get(broadcast_id);
      DebugPrint("buffer data" + bufferdata.toString());
      bufferdata.forEach(
        (contentName, value) {
          if (contentName != "broadcast_start_datetime") {
            DebugPrint(" bufferdata.forEach key = $contentName");
            DebugPrint(" bufferdata.forEach value = $value");

            String content_name = value[CONTENT_NAME_KEY];
            var start_time = value[START_TIME_KEY];

            int current_duration = dateTimeNow.difference(start_time).inSeconds;
            DebugPrint("recordede box data = $recorded_data");
            //RECORD BOX DOESNT CONTAIN BROADCAST ID
            if (!recorded_box.containsKey(broadcast_id)) {
              DebugPrint("recoreded box doesnt contain broadcast id");
              recorded_box.put(broadcast_id, {
                content_name: {
                  CONTENT_DURATION_KEY: current_duration,
                  CONTENT_COUNT_KEY: 0
                }
              });
            }
            //ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME
            else if (!recorded_data!.containsKey(content_name)) {
              DebugPrint(
                  "ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME");
              String content_name = value[CONTENT_NAME_KEY];
              int duration = dateTimeNow.difference(start_time).inSeconds;
              recorded_data[content_name] = {
                CONTENT_DURATION_KEY: duration,
                CONTENT_COUNT_KEY: 0
              };

              recorded_box.put(broadcast_id, recorded_data);
            }
            //ALREADY BROADCAST ADDED ALSO CONTENT ADDED
            else if (recorded_data.containsKey(content_name)) {
              DebugPrint("ALREADY BROADCAST ADDED ALSO CONTENT ADDED");
              double past_duration = ((recorded_data[content_name]
                      [CONTENT_DURATION_KEY]))
                  .toDouble();
              int past_count = recorded_data[content_name][CONTENT_COUNT_KEY];
              int current_duration =
                  dateTimeNow.difference(start_time).inSeconds;
              double updated_duration = past_duration + current_duration;
              recorded_data[content_name] = {
                CONTENT_DURATION_KEY: updated_duration,
                CONTENT_COUNT_KEY: past_count
              };

              recorded_box.put(broadcast_id, recorded_data);
            }
          }
        },
      );

      Map<dynamic, dynamic> recorded_data_after_complete = {
        ...recorded_box.get(broadcast_id)
      };
      recorded_data_after_complete[IS_COMPLETED_KEY] = true;
      DateTime end_time = await last_saved_time_box.get(LAST_SAVED_TIME_KEY);
      recorded_data_after_complete[BROADCAST_END_TIME_KEY] = end_time;

      recorded_box.put(broadcast_id, recorded_data_after_complete);
      buffer_box.delete(broadcast_id);

      bool connection_result = await InternetConnection().hasInternetAccess;
      if (connection_result) {
        addToServer();
      }
      // ADD TO SERVER //
    } else {}
  });
}

void addToServer() async {
  DebugPrint("ADD TO SERVER CALLEDDDDDDDDDDDDDDDDDDDDD");

  var recorded_keys = recorded_box.keys;
  DebugPrint("keeesys = $recorded_keys");
  recorded_keys.forEach(
    (element) async {
      Map recorded_data = recorded_box.get(element);
      DebugPrint("recoreded data  = $recorded_data");

      if (recorded_data[IS_COMPLETED_KEY]) {
        final prefs = await SharedPreferences.getInstance();
        String? screenCode = prefs.getString("NewScreenCode");
        Map jsonData = {};
        jsonData["screen_code"] = screenCode;

        jsonData["broadcast_id"] = element;

        jsonData["broadcast_start_datetime"] =
            recorded_data[BROADCAST_START_TIME_KEY].toString();
        jsonData["broadcast_end_datetime"] =
            recorded_data[BROADCAST_END_TIME_KEY].toString();

        List content_history = [];

        recorded_data.forEach((key, value) {
          if (key != IS_COMPLETED_KEY &&
              key != BROADCAST_END_TIME_KEY &&
              key != BROADCAST_START_TIME_KEY) {
            Map content_data = {};

            content_data["content_name"] = key;
            content_data["content_duration"] = value[CONTENT_DURATION_KEY];
            content_data["content_count"] = value[CONTENT_COUNT_KEY];
            content_history.add(content_data);
          }
        });
        jsonData["content_history"] = content_history;

        // convert to proper json format

        // API CALLL;

        // API CALLING
        DebugPrint("json before decodingggggg");

        DebugPrint(jsonData);
        DebugPrint("send dataaaaaaaaaaaaaaaaaaaaaaaaaaaa = ${jsonEncode(jsonData)}");

        ContentLogsRepository().sendContentLogs(jsonData);

        await buffer_box.delete(element);
        await recorded_box.delete(element);
      }
    },
  );

  DebugPrint("***** DATAS ADDED TO SERVER *********");
  DebugPrint(recorded_box.keys);
  DebugPrint(recorded_box.values);
}

void printValues() {
  DebugPrint("BUFFER keys");
  DebugPrint(buffer_box.keys);
  DebugPrint("BUFFER values");
  DebugPrint(buffer_box.values);

  DebugPrint("RECORDED keys");
  DebugPrint(recorded_box.keys);
  DebugPrint("RECORDED VALUES");
  DebugPrint(recorded_box.values);
}

// bufferdata={

//   broadcast_id:    {

// BROADCAST_START_TIME_KEY:"00:00:00",
// BROADCAST_END_TIME_KEY:"00:00:00"

//     zoneno : {
//               CONTENT_NAME_KEY:contentname,
//               CONTENT_DURATION_KEY:contentDuration,
//               START_TIME_KEY:dateTime

//               }
//                   };

//     zoneno : {
//
//               CONTENT_NAME_KEY:contentname,
//               CONTENT_DURATION_KEY:contentDuration,
//               START_TIME_KEY:dateTime

//               }
//                   };

//   }
// }

// recorded_data={
//   broadcast_id : {
// BROADCAST_START_TIME_KEY:"00:00:00",
// BROADCAST_END_TIME_KEY:"00:00:00"
// IS_COMPLETED_KEY:true

//     CONTENT_NAME_KEY: {"duration":contentDuration,"count":1}

//   }
// }

// API : create content logs for a user :  /api/content-logs/
// POST method
// {
//     "screen_code": "96SVXQ",
//     "broadcast_id": 126,
//     "broadcast_start_datetime": "2023-12-03T10:00:00Z",
//     "broadcast_end_datetime": "2023-12-03T10:00:00Z",
//     "content_history":[
//         {
//             "content_id":1,
//             "content_name": "name1",
//             "content_duration": 100
//         },
//         {
//             "content_id":2,
//             "content_name": "name2",
//             "content_duration": 100
//         }
//     ]

//     }
