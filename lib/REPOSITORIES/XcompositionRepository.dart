// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:digitalsignange/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/BroadCastModel.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';



// String dummyresponce="""{
//     "data": {
//         "first_broadcast_data": {
//             "id": 25,
//             "name": "test",
//             "message": "Live Broadcast",
//             "current_datetime": "2025-01-09T12:54:58",
//             "updated_datetime": "2025-01-09T12:54:54",
//             "start_datetime": "2025-01-08T09:00:01",
//             "end_datetime": "2025-01-24T18:00:00",
//             "orientation_angle": 0,
//             "zone_count": 1,
//             "zone_data": [
//                 {
//                     "id": 1,
//                     "name": "Zone 1",
//                     "widthPercent": 100,
//                     "heightPercent": 100,
//                     "xPercent": 0,
//                     "yPercent": 0,
//                     "contents": [
//                         {
//                             "content_id": 168,
//                             "content_name": "ForBiggerEscapes",
//                             "file_upload": "/media/uploads/12/files/ForBiggerEscapes.mp4",
//                             "file_format": "mp4",
//                             "duration": "15.0",
//                             "sort_order": 1
//                         },
//                         {
//                             "content_id": 170,
//                             "content_name": "apple",
//                             "file_upload": "/media/uploads/12/files/apple.jpeg",
//                             "file_format": "jpeg",
//                             "duration": "10.0",
//                             "sort_order": 2
//                         }
//                     ]
//                 }
//             ]
//         },
//         "second_broadcast_data": {
//             "message": "No other broadcast"
//         }
//     },
//     "message": "Screen is registered"
// }""";


// String dummyresponce = """{
//     "data": {
//         "first_broadcast_data": {
//             "id": 19,
//             "name": "App Test broadcast",
//             "message": "Live Broadcast",
//             "current_datetime": "2025-01-20T10:25:05",
//             "updated_datetime": "2025-01-20T10:24:59",
//             "start_datetime": "2025-01-20T08:45:01",
//             "end_datetime": "2025-01-22T22:50:00",
//             "orientation_angle": 0,
//             "zone_count": 1,
//             "zone_data": [
//                 {
//                     "id": 1,
//                     "name": "Zone 1",
//                     "xPercent": 0,
//                     "yPercent": 0,
//                     "widthPercent": 100,
//                     "heightPercent": 100,
//                     "contents": [
//                         {
//                             "content_id": 69,
//                             "content_name": "Sample Titleq",
//                             "content_type": "app",
//                             "file_upload": "https://www.scalgo.net/",
//                             "file_format": ".html",
//                             "app_type": "clock",
//                             "duration": "10.0",
//                             "sort_order": 1
//                         }
//                     ]
//                 }
//             ]
//         },
//         "second_broadcast_data": {
//             "message": "No other broadcast"
//       }
//     },
//     "message": "Screen is registered"
// }""";


String dummyresponce = """{
    "data": {
        "first_broadcast_data": {
            "id": 25,
            "name": "App Test broadcast",
            "message": "Live Broadcast",
            "current_datetime": "2025-01-21T14:22:47",
            "updated_datetime": "2025-01-21T14:22:44",
            "start_datetime": "2025-01-21T14:24:01",
            "end_datetime": "2025-01-21T19:50:00",
            "orientation_angle": 0,
            "zone_count": 2,
            "zone_data": [
                {
                    "id": 1,
                    "name": "Zone 1",
                    "xPercent": 0,
                    "yPercent": 0,
                    "widthPercent": 50,
                    "heightPercent": 100,
                    "contents": [
                        {
                            "content_id": 71,
                            "content_name": "sssssssssss",
                            "file_upload": "/media/uploads/2/files/butterfly_YR5ZS8K.jpg",
                            "file_format": ".jpg",
                            "app_type": "default",
                            "content_type": "media",
                            "duration": "10.0",
                            "sort_order": 1
                        },
                        {
                            "content_id": 70,
                            "content_name": "sssssssssss",
                            "file_upload": "/media/uploads/2/files/rose.jpg",
                            "file_format": ".jpg",
                            "app_type": "default",
                            "content_type": "media",
                            "duration": "10.0",
                            "sort_order": 2
                        }
                    ]
                },
                {
                    "id": 2,
                    "name": "Zone 2",
                    "xPercent": 50,
                    "yPercent": 0,
                    "widthPercent": 50,
                    "heightPercent": 100,
                    "contents": [
                        {
                            "content_id": 72,
                            "content_name": "sssssssssss",
                            "file_upload": "/media/uploads/2/files/white.jpeg",
                            "file_format": ".jpeg",
                            "app_type": "default",
                            "content_type": "media",
                            "duration": "10.0",
                            "sort_order": 1
                        },
                        {
                            "content_id": 69,
                            "content_name": "Sample Titleq",
                            "file_upload": "https://www.scalgo.net/",
                            "file_format": ".html",
                            "app_type": "clock",
                            "content_type": "app",
                            "duration": "10.0",
                            "sort_order": 1
                        }
                    ]
                }
            ]
        },
        "second_broadcast_data": {
            "message": "No other broadcast"
        }
    },
    "message": "Screen is registered"
}""";



class LayoutRepository {
  Future<BroadCastModel?> newFetchData(String code) async {
    print("enteringggg");
    LayoutData? currentBroadcastData;
    LayoutData? nextBroadcastData;
    String data_url = '$BASEURL/api/launch-signage-screen/?code=$code';
    var response = await http.get(Uri.parse(data_url));
    // BroadCastModel? broadCastData;
    if (response.statusCode == 200) {






       var jsonData = json.decode(response.body);
        // var jsonData = json.decode(responce);
      String? screenStatus = jsonData["message"];
      print("data1 = ${jsonData["data"]["first_broadcast_data"]}");
      if (jsonData["data"]["first_broadcast_data"]['message'] ==
          "Live Broadcast") {
        currentBroadcastData =
            LayoutData.fromJson(jsonData["data"]["first_broadcast_data"]);
      } else {
        currentBroadcastData = null;
      }

      if (jsonData["data"]["second_broadcast_data"]['message'] ==
          "Live Broadcast") {
        nextBroadcastData =
            LayoutData.fromJson(jsonData["data"]["second_broadcast_data"]);
      } else {
        nextBroadcastData = null;
      }

      BroadCastModel broadCastData = BroadCastModel(
          message: screenStatus,
          currentBroadCast: currentBroadcastData,
          NextBroadCast: nextBroadcastData,
          layoutrespInString: response.body);
      // layoutdata.zoneData!.forEach((element) {
      //   element.compositionModels
      //       .removeWhere((content) => content.fileDuration == '0.0');
      // });
      return broadCastData;
    } else {
      print(" irresponse error");
      var jsonData = json.decode(response.body);
      log("message1 = ${jsonData["message"]}");
      // String screenStatus = jsonData["message"];
      BroadCastModel broadCastData = BroadCastModel(
        message: jsonData["message"],
        currentBroadCast: null,
        NextBroadCast: null,
      );
      return broadCastData;
    }
  }

  Future<BroadCastModel?> fetchDataFromStorage(String responce) async {
    LayoutData? currentBroadcastData;
    LayoutData? nextBroadcastData;

    // BroadCastModel? broadCastData;

    var jsonData = json.decode(responce);
    String? screenStatus = jsonData["message"];
    print("data1 = ${jsonData["data"]["first_broadcast_data"]}");
    if (jsonData["data"]["first_broadcast_data"]['message'] ==
        "Live Broadcast") {
      currentBroadcastData =
          LayoutData.fromJson(jsonData["data"]["first_broadcast_data"]);
    } else {
      currentBroadcastData = null;
    }

    if (jsonData["data"]["second_broadcast_data"]['message'] ==
        "Live Broadcast") {
      nextBroadcastData =
          LayoutData.fromJson(jsonData["data"]["second_broadcast_data"]);
    } else {
      nextBroadcastData = null;
    }

    BroadCastModel broadCastData = BroadCastModel(
        message: screenStatus,
        currentBroadCast: currentBroadcastData,
        NextBroadCast: nextBroadcastData,
        layoutrespInString: responce);

    // layoutdata.zoneData!.forEach((element) {
    //   element.compositionModels
    //       .removeWhere((content) => content.fileDuration == '0.0');
    // });
    return broadCastData;
  }
}
