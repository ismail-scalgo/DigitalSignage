// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// late Box buffer_box;
// late Box recorded_box;
// late SharedPreferences prefs;
// String? screenCode = prefs.getString('NewScreenCode');
// StreamController controller = StreamController();
// Stream stream = controller.stream;

// String CONTENT_NAME_KEY="content_name";
// String CONTENT_DURATION_KEY="content_duration";
// String START_TIME_KEY="start_time";

// Future init() async
// {

//   prefs = await SharedPreferences.getInstance();

//   bool connection_result = await InternetConnection().hasInternetAccess;
//   buffer_box = await Hive.openBox("buffer_box");

//   recorded_box = await Hive.openBox("recorded_box");

//   stream.listen((value) async {

//     Map eventValue=value;

//     if(eventValue['event']=="content_add_event");
//     {
//       addlogToBuffer(broadcast_id:  eventValue['broadcast_id'],contentname:  eventValue['content_name'],contentDuration:  eventValue['content_duration'],zoneno:  eventValue['content_zone']);
//     }
//     if(eventValue['event']=="broadcast_end_event")
//     {
//       addtoRecordFromBufferOnEnd(broadcast_id:  eventValue['broadcast_id']);
//     }

//   });

// }

// Future addlogToBuffer({required String broadcast_id,required String contentname,required double contentDuration,required int zoneno}) async
// {

//       DateTime dateTime = DateTime.now();

//     var buffer_datas =  buffer_box.keys;
//    //IF ANY PENDING BROADCAST IN THE BUFFER
//     if(buffer_datas.length > 1)
//     {

//       buffer_box.keys.forEach((key) async {

//         if(key != broadcast_id)
//         {

//            await addtoRecordFromBufferOnEnd(broadcast_id:  key);

//         }

//       });

//     }

//       //if it is first no logs created
//       //create new
//       if(!buffer_box.containsKey(broadcast_id))
//       {

//         Map content_value={
//           zoneno : {
//               CONTENT_NAME_KEY:contentname,
//               CONTENT_DURATION_KEY:contentDuration,
//               START_TIME_KEY:dateTime

//           } };

//         buffer_box.put(broadcast_id, content_value);

//       }
//       else
//       {

//         // current zone entry is new

//         Map bufferdata=buffer_box.get(broadcast_id);

//         if(bufferdata.containsKey(zoneno))
//         {

//               addtoRecordOnNormalCondition(broadcast_id, bufferdata, zoneno);

//             //********* ADD TO RECORDED DATA**********//

//         }

//         bufferdata[zoneno]  =  {
//               CONTENT_NAME_KEY:contentname,
//               CONTENT_DURATION_KEY:contentDuration,
//               START_TIME_KEY:dateTime

//         };

//         buffer_box.put(broadcast_id, bufferdata);

//       }

// }

// Future addtoRecordOnNormalCondition(String broadcast_id,Map bufferdata,int zone) async
// {

//     String content_name=bufferdata[broadcast_id][zone][CONTENT_NAME_KEY];
//     Map? recorded_data=recorded_box.get(broadcast_id);

//     //VERY FIRST TIME WITHOUT CONTAINS BROADCAST ID
//     if(!recorded_box.containsKey(broadcast_id))
//     {
//       String content_name=bufferdata[broadcast_id][zone][CONTENT_NAME_KEY];
//       double current_duration=bufferdata[broadcast_id][zone][CONTENT_DURATION_KEY];

//        recorded_box.put(broadcast_id, {content_name:current_duration});

//     }
//     //ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME
//     else if(!recorded_data!.containsKey(content_name))
//     {
//       String content_name=bufferdata[broadcast_id][zone][CONTENT_NAME_KEY];
//       double current_duration=bufferdata[broadcast_id][zone][CONTENT_DURATION_KEY];
//       recorded_data[content_name]=current_duration;
//       recorded_box.put(broadcast_id, recorded_data);
//     }
//     //ALREADY BROADCAST ADDED ALSO CONTENT ADDED
//     else if(recorded_data.containsKey(content_name))
//     {
//         double past_duration = recorded_data[content_name];
//         double current_duration = bufferdata[broadcast_id][zone][CONTENT_DURATION_KEY];
//         double updated_duration = past_duration+current_duration;
//         recorded_data[content_name] = current_duration;
//         recorded_box.put(broadcast_id, recorded_data);
//     }

// }

// Future addtoRecordFromBufferOnEnd({required String? broadcast_id}) async
// {

//      // check any logs on buffer and add to to recorded data

//     Map? bufferdata=buffer_box.get(broadcast_id);
//     DateTime dateTimeNow = DateTime.now();
//     if(bufferdata!=null)
//     {

//       Map? recorded_data=recorded_box.get(broadcast_id);

//       bufferdata.forEach((key, value) {
//          String content_name=value[CONTENT_NAME_KEY];
//          DateTime start_time=value[START_TIME_KEY];

//            int current_duration=dateTimeNow.difference(start_time).inSeconds;

//              if(!recorded_box.containsKey(broadcast_id))
//               {

//                  recorded_box.put(broadcast_id, {content_name:current_duration});

//               }
//               //ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME
//     else if(!recorded_data!.containsKey(content_name))
//     {
//       String content_name=value[CONTENT_NAME_KEY];
//       int duration=dateTimeNow.difference(start_time).inSeconds;
//       recorded_data[content_name]=duration;
//       recorded_box.put(broadcast_id, recorded_data);
//     }
//      //ALREADY BROADCAST ADDED ALSO CONTENT ADDED
//     else if(recorded_data.containsKey(content_name))
//     {
//         double past_duration = recorded_data[content_name];
//         int current_duration = dateTimeNow.difference(start_time).inSeconds;
//         double updated_duration = past_duration+current_duration;
//         recorded_data[content_name] = updated_duration;
//         recorded_box.put(broadcast_id, recorded_data);
//     }

//       },);

//       // ADD TO SERVER //

//       addToServer();

//     buffer_box.delete(broadcast_id);

//     }
//     else
//     {

//     }

// }

// void addToServer()
// {
//     print("******* ADD TO SERVER CALLEDDDDDDDDDDD  ***********");
//     print(recorded_box.keys);
//     print(recorded_box.values);

// }

// void printValues()
// {

//   print("BUFFER VALUES");
//   print(buffer_box.keys);
//   print(buffer_box.values);

//   print("RECORDED VALUES");
//   print(recorded_box.keys);
//   print(recorded_box.values);

// }

// // bufferdata={

// //   broadcast_id:    {

// //     zoneno : {
// //               CONTENT_NAME_KEY:contentname,
// //               CONTENT_DURATION_KEY:contentDuration,
// //               START_TIME_KEY:dateTime

// //               }
// //                   };

// //     zoneno : {
// //
// //               CONTENT_NAME_KEY:contentname,
// //               CONTENT_DURATION_KEY:contentDuration,
// //               START_TIME_KEY:dateTime

// //               }
// //                   };

// //   }
// // }

//             // recorded_data={
//             //   broadcast_id : {
//             //     CONTENT_NAME_KEY: contentDuration

//             //   }
//             // }

// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digitalsignange/REPOSITORIES/ContentLogRepo.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Box buffer_box;
late Box recorded_box;
late SharedPreferences prefs;
String? screenCode = prefs.getString('NewScreenCode');
StreamController controller = StreamController();
Stream stream = controller.stream;
String CONTENT_NAME_KEY = "content_name";
String CONTENT_DURATION_KEY = "content_duration";
String START_TIME_KEY = "start_time";
String IS_COMPLETED_KEY = "is_completed";

Future init() async {
  Directory appDocumentDir =
      await getApplicationDocumentsDirectory(); // Get the app's document directory
  Hive.init(appDocumentDir.path);
  prefs = await SharedPreferences.getInstance();

  buffer_box = await Hive.openBox("buffer_box");

  recorded_box = await Hive.openBox("recorded_box");

  stream.listen((value) async {

    print("NEW STREAM ADDEDDDDDDDDDDDD");
    Map eventValue = value;
    if (eventValue['event'] == "content_add_event") {
      print("oooooooooooook");
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

Future addlogToBuffer(
    {required String broadcast_id,
    required String contentname,
    required double contentDuration,
    required int zoneno}) async {
  DateTime dateTime = DateTime.now();

  var buffer_datas = buffer_box.keys;
  //IF ANY PENDING BROADCAST IN THE BUFFER
  print("buffer length ========== ${buffer_datas}");
  if (buffer_datas.length > 0) {
    buffer_box.keys.forEach((key) async {
      if (key != broadcast_id) {
        await addtoRecordFromBufferOnEnd();
      }
    });
  }

  //if it is first no logs created
  //create new
  if (!buffer_box.containsKey(broadcast_id)) {
    Map content_value = {
      zoneno: {
        CONTENT_NAME_KEY: contentname,
        CONTENT_DURATION_KEY: contentDuration,
        START_TIME_KEY: dateTime
      }
    };

    buffer_box.put(broadcast_id, content_value);
  } else {
    print("broadcast id already added");
    // current zone entry is new

    Map bufferdata = buffer_box.get(broadcast_id);

    if (bufferdata.containsKey(zoneno)) {
      print("zone already addded");
      await addtoRecordOnNormalCondition(broadcast_id, bufferdata, zoneno);

      //********* ADD TO RECORDED DATA**********//
    }

    bufferdata[zoneno] = {
      CONTENT_NAME_KEY: contentname,
      CONTENT_DURATION_KEY: contentDuration,
      START_TIME_KEY: dateTime
    };

    buffer_box.put(broadcast_id, bufferdata);
  }
  printValues();
}

Future addtoRecordOnNormalCondition(
    String broadcast_id, Map bufferdata, int zone) async {
  print("zone = $zone");
  print("buffer data = $bufferdata");
  String content_name = (buffer_box.get(broadcast_id))[zone][CONTENT_NAME_KEY];
  Map? recorded_data = recorded_box.get(broadcast_id);

  //VERY FIRST TIME WITHOUT CONTAINS BROADCAST ID
  if (!recorded_box.containsKey(broadcast_id)) {
    print("VERY FIRST TIME WITHOUT CONTAINS BROADCAST ID");
    String content_name =
        (buffer_box.get(broadcast_id))[zone][CONTENT_NAME_KEY];
    double current_duration =
        (buffer_box.get(broadcast_id))[zone][CONTENT_DURATION_KEY];

    recorded_box
        .put(broadcast_id, {content_name: current_duration, IS_COMPLETED_KEY: false});

  }
  //ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME
  else if (!recorded_data!.containsKey(content_name)) {
    print("ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME");
    String content_name =
        (buffer_box.get(broadcast_id))[zone][CONTENT_NAME_KEY];
    double current_duration =
        (buffer_box.get(broadcast_id))[zone][CONTENT_DURATION_KEY];
    recorded_data[content_name] = current_duration;
    recorded_box.put(broadcast_id, recorded_data);
  }
  //ALREADY BROADCAST ADDED ALSO CONTENT ADDED
  else if (recorded_data.containsKey(content_name)) {
    print("/ALREADY BROADCAST ADDED ALSO CONTENT ADDED");
    double past_duration = recorded_data[content_name];
    double current_duration = (buffer_box.get(broadcast_id))[zone][CONTENT_DURATION_KEY];
    double updated_duration = past_duration + current_duration;
    recorded_data[content_name] = updated_duration;
    recorded_box.put(broadcast_id, recorded_data);
  }
}

Future addtoRecordFromBufferOnEnd() async {
  // check any logs on buffer and add to to recorded data

  var buffer_box_data = buffer_box.keys;

  // ITERATE ALL BROADCAST ID FROM BUFFER
  buffer_box_data.forEach((broadcast_id) async {
    print("buffer_box_data keys = $broadcast_id");

    Map? bufferdata = buffer_box.get(broadcast_id);
    DateTime dateTimeNow = DateTime.now();
       Map? recorded_data = recorded_box.get(broadcast_id);
       print("dataaaaaaaaaa = $recorded_data");
    if (bufferdata != null) {
      Map? recorded_data = recorded_box.get(broadcast_id);
      print('recorded_data = $recorded_data');

      bufferdata.forEach((contentName, value) {
          print(" bufferdata.forEach key = $contentName");
          print(" bufferdata.forEach value = $value");
          String content_name = value[CONTENT_NAME_KEY];
          DateTime start_time = value[START_TIME_KEY];

          int current_duration = dateTimeNow.difference(start_time).inSeconds;
          print("recordede box data = $recorded_data");
            //RECORD BOX DOESNT CONTAIN BROADCAST ID
          if (!recorded_box.containsKey(broadcast_id)) {
          print("recoreded box doesnt contain broadcast id");
            recorded_box.put(broadcast_id, {content_name: current_duration });
          }
          //ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME
          else if (!recorded_data!.containsKey(content_name)) {
          print("ALREADY BROADCAST ADDED BUT THE CONTENT KEY IS FOR FIRST TIME");
            String content_name = value[CONTENT_NAME_KEY];
            int duration = dateTimeNow.difference(start_time).inSeconds;
            recorded_data[content_name] = duration;
           
            recorded_box.put(broadcast_id, recorded_data);
          }
          //ALREADY BROADCAST ADDED ALSO CONTENT ADDED
          else if (recorded_data.containsKey(content_name)) {
          print("ALREADY BROADCAST ADDED ALSO CONTENT ADDED");
            double past_duration = recorded_data[content_name];
            int current_duration = dateTimeNow.difference(start_time).inSeconds;
            double updated_duration = past_duration + current_duration;
            recorded_data[content_name] = updated_duration;

            recorded_box.put(broadcast_id, recorded_data);
          }
        },
      );

      Map<dynamic,dynamic> recorded_data_after_complete = {...recorded_box.get(broadcast_id)};
      recorded_data_after_complete[IS_COMPLETED_KEY] = true;
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
  print("ADD TO SERVER CALLEDDDDDDDDDDDDDDDDDDDDD");

  var recorded_keys = recorded_box.keys;
  print("keeesys = $recorded_keys");
  recorded_keys.forEach(
    (element) async {
      Map recorded_data = recorded_box.get(element);
      print("recoreded data  = $recorded_data");

      print(recorded_data);
      if (recorded_data[IS_COMPLETED_KEY]) {
        final prefs = await SharedPreferences.getInstance();
        String? screenCode = prefs.getString("NewScreenCode");
        Map jsonData = {};
        jsonData["screen_code"] = screenCode;

        jsonData["broadcast_id"] = element;

        jsonData["broadcast_start_datetime"] = "2023-12-03T10:00:00Z";
        jsonData["broadcast_end_datetime"] = "2023-12-03T10:00:00Z";

        List content_history = [];

        recorded_data.forEach((key, value) {
          if (key != IS_COMPLETED_KEY) {
            Map content_data = {};

            content_data["content_name"] = key;
            content_data["content_duration"] = value;
            content_history.add(content_data);
          }
        });
        jsonData["content_history"]=content_history;

        // convert to proper json format

        // API CALLL;

        // API CALLING
        print("send dataaaaaaaaaaaaaaaaaaaaaaaaaaaa = ${jsonEncode(jsonData)}");

         ContentLogsRepository().sendContentLogs(jsonData);

       await  buffer_box.delete(element);
      }
    },
  );

  print("***** ADD TO SERVER CALLEDDDDDDDDDDD  *********");
  print(recorded_box.keys);
  print(recorded_box.values);
}

void printValues() {
  print("BUFFER keys");
  print(buffer_box.keys);
    print("BUFFER values");
  print(buffer_box.values);

  print("RECORDED keys");
  print(recorded_box.keys);
   print("RECORDED VALUES");
  print(recorded_box.values);
}

// bufferdata={

//   broadcast_id:    {

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
//     IS_COMPLETED_KEY:true

//     CONTENT_NAME_KEY: contentDuration

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
