// ignore_for_file: unused_local_variable

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/BroadCastModel.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LayoutRepository {
  Future<LayoutData?> fetchData(String code) async {
    String data_url = '$BASEURL/api/launch-signage-screen/?code=$code';
    // String data_url = 'https://web-dev-sgdsignage.scalgo.net/api/launch-signage-screen/?code=$code';
    var response = await http.get(Uri.parse(data_url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // jsonData["data"]['current_datetime'] = "2024-09-24T10:37:20";
      // jsonData["data"]['start_datetime'] = "2024-09-24T10:37:40";
      // jsonData["data"]['end_datetime'] = "2024-09-24T10:37:50";
      // jsonData["data"]['orientation_angle'] = 0;
      print("new res = $jsonData");

      // jsonData = {
      //   "name": "Layout 3",
      //   "zone_count": 3,
      //   "start_time": "2024-09-03T10:18:00",
      //   "end_time": "2024-09-03T10:19:40",
      //   "orientation_angle": 180,
      //   "current_datetime": "2024-09-03T10:17:50",
      //   "zone_data": [
      //     {
      //       "id": 1,
      //       "name": "Zone 1",
      //       "xPercent": 0,
      //       "yPercent": 0,
      //       "widthPercent": 100,
      //       "heightPercent": 100,
      //       "contents": [
      //         {
      //           "file_upload": "/media/uploads/Adv_video_xj7FDL5.mp4",
      //           "file_format": "mp4",
      //           "file_duration": "12.0"
      //         },
      //         {
      //           "file_upload": "/media/uploads/sample_1280853.jpeg",
      //           "file_format": "jpeg",
      //           "file_duration": "12"
      //         }
      //         //               {
      //         //   "file_upload":
      //         //       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
      //         //   "file_format": "mp4",
      //         //   "file_duration": "15"
      //         // },
      //         // {
      //         //   "file_upload":
      //         //       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
      //         //   "file_format": "mp4",
      //         //   "file_duration": "15"
      //         // },
      //         // {
      //         //   "file_upload":
      //         //       "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      //         //   "file_format": "pdf",
      //         //   "file_duration": "15"
      //         // },
      //         // {
      //         //   "file_upload":
      //         //       "https://images.pexels.com/photos/24869081/pexels-photo-24869081/free-photo-of-a-table-with-two-plates-of-food-and-wine.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      //         //   "file_format": "jpeg",
      //         //   "file_duration": "10"
      //         // },
      //       ]
      //     },
      //     // {
      //     //   "id": 2,
      //     //   "name": "Zone 2",
      //     //   "xPercent": 80,
      //     //   "yPercent": 0,
      //     //   "widthPercent": 65,
      //     //   "heightPercent": 50,
      //     //   "contents": [
      //     //     {
      //     //       "file_upload":
      //     //           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
      //     //       "file_format": "mp4",
      //     //       "file_duration": "15"
      //     //     },
      //     //     {
      //     //       "file_upload":
      //     //           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
      //     //       "file_format": "mp4",
      //     //       "file_duration": "15"
      //     //     },
      //     //   ]
      //     // },
      //     // {
      //     //   "id": 3,
      //     //   "name": "Zone 3",
      //     //   "xPercent": 0,
      //     //   "yPercent": 70,
      //     //   "widthPercent": 65,
      //     //   "heightPercent": 50,
      //     //   "contents": [
      //     //     {
      //     //       "file_upload":
      //     //           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
      //     //       "file_format": "mp4",
      //     //       "file_duration": "15"
      //     //     },
      //     //     {
      //     //       "file_upload":
      //     //           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
      //     //       "file_format": "mp4",
      //     //       "file_duration": "15"
      //     //     },
      //     //   ]
      //     // },
      //     // {
      //     //   "id": 4,
      //     //   "name": "Zone 2",
      //     //   "xPercent": 80,
      //     //   "yPercent": 0,
      //     //   "widthPercent": 35,
      //     //   "heightPercent": 50,
      //     //   "contents": [
      //     //     {
      //     //       "file_upload":
      //     //           "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      //     //       "file_format": "pdf",
      //     //       "file_duration": "15"
      //     //     },
      //     //     {
      //     //       "file_upload":
      //     //           "https://images.pexels.com/photos/24869081/pexels-photo-24869081/free-photo-of-a-table-with-two-plates-of-food-and-wine.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      //     //       "file_format": "jpeg",
      //     //       "file_duration": "10"
      //     //     },
      //     //   ]
      //     // },
      //   ]
      // };
      if (jsonData["data"]["message"] == "No Broadcast") {
        print("no broadcast");
        return null;
      } else {
        LayoutData layoutdata = LayoutData.fromJson(jsonData["data"]);
        layoutdata.zoneData!.forEach((element) {
          element.compositionModels
              .removeWhere((content) => content.fileDuration == '0.0');
        });
        return layoutdata;
      }
    }
  }

  Future<BroadCastModel?> newFetchData(String code) async {
    print("enteringggg");
    String data_url = '$BASEURL/api/launch-signage-screen/?code=$code';
    var response = await http.get(Uri.parse(data_url));
    // BroadCastModel? broadCastData;
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // jsonData = {
      //   "data": {
      //     "first_broadcast_data": {
      //       "id": 75,
      //       "name": "Layout 3",
      //       "message": "Live Broadcast",
      //       "current_datetime": "2024-09-30T06:40:23",
      //       "updated_datetime": "2024-09-30T06:19:46",
      //       "start_datetime": "2024-09-30T06:41:00",
      //       "end_datetime": "2024-09-30T06:41:30",
      //       "orientation_angle": 90,
      //       "zone_count": 3,
      //       "zone_data": [
      //         {
      //           "id": 1,
      //           "name": "Zone 1",
      //           "xPercent": 0,
      //           "yPercent": 0,
      //           "widthPercent": 80,
      //           "heightPercent": 70,
      //           "contents": [
      //             {
      //               "file_upload": "/media/uploads/Adv_video_BEkxyj7.mp4",
      //               "file_format": "mp4",
      //               "duration": "30.0"
      //             },
      //             {
      //               "file_upload": "/media/uploads/Adv_image.jpg",
      //               "file_format": "jpg",
      //               "duration": "40.0"
      //             },
      //             {
      //               "file_upload": "/media/uploads/Adv_video_BEkxyj7.mp4",
      //               "file_format": "mp4",
      //               "duration": "10.0"
      //             }
      //           ]
      //         },
      //         {
      //           "id": 2,
      //           "name": "Zone 2",
      //           "xPercent": 80,
      //           "yPercent": 0,
      //           "widthPercent": 20,
      //           "heightPercent": 70,
      //           "contents": [
      //             {
      //               "file_upload": "/media/uploads/Adv_image.jpg",
      //               "file_format": "jpg",
      //               "duration": "50.0"
      //             }
      //           ]
      //         },
      //         {
      //           "id": 3,
      //           "name": "Zone 3",
      //           "xPercent": 0,
      //           "yPercent": 70,
      //           "widthPercent": 100,
      //           "heightPercent": 30,
      //           "contents": [
      //             {
      //               "file_upload": "/media/uploads/Adv_video_BEkxyj7.mp4",
      //               "file_format": "mp4",
      //               "duration": "60.0"
      //             }
      //           ]
      //         }
      //       ]
      //     },
      //     "second_broadcast_data": {
      //       "id": 78,
      //       "name": "Layout 1",
      //       "message": "Live Broadcast",
      //       "current_datetime": "2024-09-30T06:40:50",
      //       "updated_datetime": "2024-09-30T06:19:46",
      //       "start_datetime": "2024-09-30T06:42:30",
      //       "end_datetime": "2024-09-30T06:43:00",
      //       "orientation_angle": 90,
      //       "zone_count": 1,
      //       "zone_data": [
      //         {
      //           "id": 1,
      //           "name": "Zone 1",
      //           "xPercent": 0,
      //           "yPercent": 0,
      //           "widthPercent": 100,
      //           "heightPercent": 100,
      //           "contents": [
      //             {
      //               "file_upload": "/media/uploads/Adv_video_BEkxyj7.mp4",
      //               "file_format": "mp4",
      //               "duration": "30.0"
      //             },
      //             {
      //               "file_upload": "/media/uploads/Adv_image.jpg",
      //               "file_format": "jpg",
      //               "duration": "40.0"
      //             },
      //             {
      //               "file_upload": "/media/uploads/Adv_video_BEkxyj7.mp4",
      //               "file_format": "mp4",
      //               "duration": "10.0"
      //             }
      //           ]
      //         },
      // {
      //   "id": 2,
      //   "name": "Zone 2",
      //   "xPercent": 80,
      //   "yPercent": 0,
      //   "widthPercent": 20,
      //   "heightPercent": 70,
      //   "contents": [
      //     {
      //       "file_upload": "/media/uploads/Adv_image.jpg",
      //       "file_format": "jpg",
      //       "duration": "50.0"
      //     }
      //   ]
      // },
      // {
      //   "id": 3,
      //   "name": "Zone 3",
      //   "xPercent": 0,
      //   "yPercent": 70,
      //   "widthPercent": 100,
      //   "heightPercent": 30,
      //   "contents": [
      //     {
      //       "file_upload": "/media/uploads/Adv_video_BEkxyj7.mp4",
      //       "file_format": "mp4",
      //       "duration": "60.0"
      //     }
      //   ]
      // }
      //       ]
      //     }
      //   }
      // };

      LayoutData? currentBroadcastData;
      LayoutData? nextBroadcastData;
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
        currentBroadCast: currentBroadcastData,
        NextBroadCast: nextBroadcastData,
      );

      // layoutdata.zoneData!.forEach((element) {
      //   element.compositionModels
      //       .removeWhere((content) => content.fileDuration == '0.0');
      // });
      return broadCastData;
    } else {
      print(" irresponse error");
    }
  }
}
