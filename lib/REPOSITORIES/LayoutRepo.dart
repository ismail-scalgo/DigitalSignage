// // // ignore_for_file: body_might_complete_normally_nullable

// // import 'package:digitalsignange/Costants.dart';
// // import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
// // import 'package:digitalsignange/MODELS/ZoneModel.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// class LayoutRepository {
//   Future<Data?> fetchResponse() async {
//     late Data responseData;
//     final apiUrl =
//         'https://web-dev-sgdsignage.scalgo.net/api/launch-signage-screen/?code=PTCUI';
//     var response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       jsonData["data"]['start_time'] = "2024-09-03T10:18:00";
//       jsonData["data"]['end_time'] = "2024-09-15T12:19:00";
//       responseData = Data.fromJson(jsonData["data"]);
//       // Data filtered_responseData=

//       responseData.zoneData.forEach((element) {
//         // element.contents.forEach((content) {
//         //   if(content.duration == "0.0") {
//         //     element.contents.remove(content);
//         //   }
//         // },);
//         element.contents.removeWhere((content) => content.duration == "0.0");
//       });

// //       // /
// //       print("jsonData  = ${jsonData}");
// //       return responseData;
// //     } else {
// //       print("Error");
// //     }
// //     // late Data responseData;
// //     // var response = await http.get(Uri.parse(
// //     //     'http://192.168.0.92:8000/api/launch-signage-screen/?code=FQVNJ'));
// //     // // print("response data = ${response.body}");
// //     // print("response data = ${response.statusCode}");
// //     // if (response.statusCode == 200) {
// //     //   final jsonData = json.decode(response.body);

// //     //   responseData = Data.fromJson(jsonData["data"]);
// //     //   print("response data = ${responseData}");
// //     //   return responseData;
// //     // } else {
// //     //   print("Error");
// //     // }

// //     //URLs
// //     //  https://web-dev-sgdsignage.scalgo.net/api/launch-signage-screen/?code=FQVNJ

// //     // https://nominatim.openstreetmap.org/reverse?lat=8.5610811&lon=76.8770507&format=json&addressdetails=1
// //     // late Data responseData;
// //     // 1st Layout
// //     // var response = {
// //     //   "name": "Layout 3",
// //     //   "zone_count": 3,
// //     // "start_time" : "2024-09-03T10:18:00",
// //     //   "end_time" : "2024-09-03T12:19:00",
// //     //   "current_time" : "2024-09-03T10:17:50",
// //     //   "zone_data": [
// //     //     {
// //     //       "id": 1,
// //     //       "name": "Zone 1",
// //     //       "xPercent": 0,
// //     //       "yPercent": 0,
// //     //       "widthPercent": 50,
// //     //       "heightPercent": 50,
// //     //       "contents": [
// //     //         {
// //     //           "file_upload":
// //     //               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
// //     //           "file_format": "mp4",
// //     //           "file_duration": "10"
// //     //         },
// //     //         {
// //     //           "file_upload":
// //     //               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
// //     //           "file_format": "mp4",
// //     //           "file_duration": "10"
// //     //         },
// //     //         {
// //     //           "file_upload":
// //     //               "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
// //     //           "file_format": "pdf",
// //     //           "file_duration": "10"
// //     //         },
// //     //       ]
// //     //     },
// //     //     {
// //     //       "id": 2,
// //     //       "name": "Zone 2",
// //     //       "xPercent": 80,
// //     //       "yPercent": 0,
// //     //       "widthPercent": 50,
// //     //       "heightPercent": 50,
// //     //       "contents": [
// //     //         {
// //     //           "file_upload":
// //     //               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
// //     //           "file_format": "mp4",
// //     //           "file_duration": "10"
// //     //         },
// //     //         {
// //     //           "file_upload":
// //     //               "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
// //     //           "file_format": "pdf",
// //     //           "file_duration": "10"
// //     //         },
// //     //         {
// //     //           "file_upload":
// //     //               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
// //     //           "file_format": "mp4",
// //     //           "file_duration": "10"
// //     //         },
// //     //       ]
// //     //     },
// //     //     {
// //     //       "id": 3,
// //     //       "name": "Zone 3",
// //     //       "xPercent": 0,
// //     //       "yPercent": 70,
// //     //       "widthPercent": 100,
// //     //       "heightPercent": 50,
// //     //       "contents": [
// //     //         {
// //     //           "file_upload":
// //     //               "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
// //     //           "file_format": "pdf",
// //     //           "file_duration": "20"
// //     //         },
// //     //         {
// //     //           "file_upload":
// //     //               "https://images.pexels.com/photos/24869081/pexels-photo-24869081/free-photo-of-a-table-with-two-plates-of-food-and-wine.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
// //     //           "file_format": "jpeg",
// //     //           "file_duration": "10"
// //     //         },
// //     //         // {
// //     //         //   "file_upload":
// //     //         //       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
// //     //         //   "file_format": "mp4",
// //     //         //   "file_duration": "10"
// //     //         // },
// //     //         // {
// //     //         //   "file_upload":
// //     //         //       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
// //     //         //   "file_format": "mp4",
// //     //         //   "file_duration": "10"
// //     //         // }
// //     //         // {
// //     //         //   "file_upload":
// //     //         //       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
// //     //         //   "file_format": "mp4",
// //     //         //   "file_duration": "500"
// //     //         // },
// //     //         // {
// //     //         //   "file_upload":
// //     //         //       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
// //     //         //   "file_format": "mp4",
// //     //         //   "file_duration": "19.0"
// //     //         // },
// //     //         // {
// //     //         //   "file_upload": "/media/uploads/pexels-kampus-5940704_hlk76KL.jpg",
// //     //         //   "file_format": "jpeg",
// //     //         //   "file_duration": "0.0"
// //     //         // }
// //     //       ]
// //     //     }
// //     //   ]
// //     // };

// //     // 2nd Layout
// //     // var response = {
// //     //   "name": "Layout 3",
// //     //   "zone_count": 3,
// //     // "start_time" : "2024-09-03T10:18:00",
// //     //   "end_time" : "2024-09-03T12:19:00",
// //     //   "current_time" : "2024-09-03T10:17:50",
// //     //   "zone_data": [
// //     //     {
// //     //       "id": 1,
// //     //       "name": "Zone 1",
// //     //       "xPercent": 0,
// //     //       "yPercent": 0,
// //     //       "widthPercent": 35,
// //     //       "heightPercent": 100,
// //     //       "contents": [
// //     //         {
// //     //           "file_upload":
// //     //               "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
// //     //           "file_format": "pdf",
// //     //           "file_duration": "30"
// //     //         },
// //     //       ]
// //     //     },
// //     //     {
// //     //       "id": 2,
// //     //       "name": "Zone 2",
// //     //       "xPercent": 80,
// //     //       "yPercent": 0,
// //     //       "widthPercent": 65,
// //     //       "heightPercent": 100,
// //     //       "contents": [
// //     //         {
// //     //           "file_upload":
// //     //               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
// //     //           "file_format": "mp4",
// //     //           "file_duration": "15"
// //     //         },
// //     //         {
// //     //           "file_upload":
// //     //               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
// //     //           "file_format": "mp4",
// //     //           "file_duration": "15"
// //     //         },
// //     //       ]
// //     //     },
// //     //   ]
// //     // };

// //     // 3rd Layout
// var response = {
//   "name": "Layout 3",
//   "zone_count": 3,
//   "start_time": "2024-09-03T10:18:00",
//   "end_time": "2024-09-03T12:19:00",
//   "current_time": "2024-09-03T10:17:50",
//   "zone_data": [
//     {
//       "id": 1,
//       "name": "Zone 1",
//       "xPercent": 0,
//       "yPercent": 0,
//       "widthPercent": 35,
//       "heightPercent": 50,
//       "contents": [
//         {
//           "file_upload":
//               "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
//           "file_format": "pdf",
//           "file_duration": "15"
//         },
//         {
//           "file_upload":
//               "https://images.pexels.com/photos/24869081/pexels-photo-24869081/free-photo-of-a-table-with-two-plates-of-food-and-wine.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
//           "file_format": "jpeg",
//           "file_duration": "10"
//         },
//       ]
//     },
//     {
//       "id": 2,
//       "name": "Zone 2",
//       "xPercent": 80,
//       "yPercent": 0,
//       "widthPercent": 65,
//       "heightPercent": 50,
//       "contents": [
//         {
//           "file_upload":
//               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
//           "file_format": "mp4",
//           "file_duration": "15"
//         },
//         {
//           "file_upload":
//               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
//           "file_format": "mp4",
//           "file_duration": "15"
//         },
//       ]
//     },
//     {
//       "id": 3,
//       "name": "Zone 3",
//       "xPercent": 0,
//       "yPercent": 70,
//       "widthPercent": 65,
//       "heightPercent": 50,
//       "contents": [
//         {
//           "file_upload":
//               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
//           "file_format": "mp4",
//           "file_duration": "15"
//         },
//         {
//           "file_upload":
//               "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
//           "file_format": "mp4",
//           "file_duration": "15"
//         },
//       ]
//     },
//     {
//       "id": 4,
//       "name": "Zone 2",
//       "xPercent": 80,
//       "yPercent": 0,
//       "widthPercent": 35,
//       "heightPercent": 50,
//       "contents": [
//         {
//           "file_upload":
//               "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
//           "file_format": "pdf",
//           "file_duration": "15"
//         },
//         {
//           "file_upload":
//               "https://images.pexels.com/photos/24869081/pexels-photo-24869081/free-photo-of-a-table-with-two-plates-of-food-and-wine.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
//           "file_format": "jpeg",
//           "file_duration": "10"
//         },
//       ]
//     },
//   ]
// };

// //     // final jsonData = json.decode(response);
// //     // responseData = Data.fromJson(response);
// //     // print("response data = ${responseData}");
// //     // return responseData;
// //   }
// // }
