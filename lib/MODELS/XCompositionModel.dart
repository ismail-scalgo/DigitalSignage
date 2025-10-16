import 'dart:convert';

import 'package:player/Utils.dart';

class CompositionModel {
  final String fileUrl;
  String filename;
  String localstoragepath;
  final String fileFormat;
  final String fileDuration;
  Map appdata;
  String appType;
  String contentType;
  String youtube_url;

  CompositionModel(
      {required this.fileUrl,
      required this.fileFormat,
      required this.localstoragepath,
      required this.fileDuration,
      required this.filename,
      required this.appType,
      required this.appdata,
      required this.contentType,
      required this.youtube_url});

  // Convert JSON to CompositionModel
  factory CompositionModel.fromJson(Map<String, dynamic> json) {
    return CompositionModel(
        fileUrl: json['file_upload'] as String,
        fileFormat: json['file_format'] as String,
        localstoragepath:
            json['localstoragepath'] == null ? '' : json['localstoragepath'],
        fileDuration: json['duration'] as String,
        filename: json['content_name'],
        appType: json["app_type"],
        appdata: json['appdata'] == null ? {} : json['appdata'],
        contentType: json['content_type'],
        youtube_url: json['youtube_url'] == null ? '' : json['youtube_url']);
  }

  Map toJson() {
    DebugPrint(
        "TO JSON OF COMPOSITION MODEL CALLED WITH LOCALSTORAGE PATH $localstoragepath");

    return {
      "app_type": appType,
      "appdata": appdata,
      "content_type": contentType,
      "content_name": filename,
      "file_upload": fileUrl,
      "file_format": fileFormat,
      "duration": fileDuration,
      "localstoragepath": localstoragepath
    };
  }
}

class ZoneData {
  final int id;
  final String name;
  final int widthPercent;
  final int heightPercent;
  final int xPercent;
  final int yPercent;
  final bool isMuted;

  final List<CompositionModel> compositionModels;

  ZoneData(
      {required this.id,
      required this.name,
      required this.widthPercent,
      required this.heightPercent,
      required this.xPercent,
      required this.yPercent,
      required this.compositionModels,
      required this.isMuted});

  // Convert JSON to ZoneData
  factory ZoneData.fromJson(Map<String, dynamic> json) {
    var CompositionModelsJson = json['contents'] as List;
    // List<CompositionModel> compositionModelsList =
    //     CompositionModelsJson.map((i) => CompositionModel.fromJson(i)).toList();

    List<CompositionModel> compositionModelsList = [];
    CompositionModelsJson.forEach((element) {
      if (element['file_format'] == "app") {
        DebugPrint("FILE TYPE IS HTML");

        Map<String, dynamic> formatteddata = {};

        formatteddata['file_upload'] = '';
        formatteddata['file_format'] = element['file_format'];
        formatteddata['localstoragepath'] = null;
        formatteddata['duration'] = element["duration"];
        formatteddata['content_name'] = element['content_name'];

        compositionModelsList.add(CompositionModel.fromJson(formatteddata));

        // localstoragepath:
        //     json['localstoragepath'] == null ? '' : jsonk['localstoragepath'],

        //  filename: json['content_name'],
        //  appdata: json['appdata'] == null ? {} : json['appdata']
      } else {
        DebugPrint("FILE TYPE IS NORMAL DATA TYPE");
        compositionModelsList.add(CompositionModel.fromJson(element));
      }
    });

    return ZoneData(
      id: json['id'] as int,
      name: json['name'] as String,
      widthPercent: json['widthPercent'] as int,
      heightPercent: json['heightPercent'] as int,
      xPercent: json['xPercent'] as int,
      yPercent: json['yPercent'] as int,
      isMuted: json['is_muted'],
      compositionModels: compositionModelsList,
    );
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
      "widthPercent": widthPercent,
      "heightPercent": heightPercent,
      "xPercent": xPercent,
      "yPercent": yPercent,
      "contents": compositionModels.map((model) => model.toJson()).toList(),
    };
  }
}

class LayoutData {
  final int? id;
  final String? name;
  final String? message;
  String? currentDatetime;
  String? startDateTime;
  String? endDateTime;
  final int? zoneCount;
  final List<ZoneData>? zoneData;
  final int oreintationAngle;
  final String? lastUpdatedAt;
  String? stringData;
  String? broadcast_type;
  

  LayoutData(
      {this.id,
      this.name,
      this.message,
      this.currentDatetime,
      this.startDateTime,
      this.endDateTime,
      this.zoneCount,
      this.zoneData,
      required this.oreintationAngle,
      this.lastUpdatedAt,
      this.stringData,
      this.broadcast_type});

  // Convert JSON to LayoutData
  factory LayoutData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.from(json);
    jsonCopy.remove("current_datetime");
    DebugPrint("from  layout");
    DebugPrint(json['orientation_angle']);
    var zoneDataJson = json['zone_data'] as List;
    List<ZoneData> zoneDataList =
        zoneDataJson.map((i) => ZoneData.fromJson(i)).toList();

    return LayoutData(
        id: json['id'] as int,
        name: json['name'] as String,
        message: json['message'] as String,
        currentDatetime: json['current_datetime'] as String,
        startDateTime: json['start_datetime'] as String,
        endDateTime: json['end_datetime'] as String,
        zoneCount: json['zone_count'] as int,
        zoneData: zoneDataList,
        lastUpdatedAt: json['updated_datetime'],
        oreintationAngle: json['orientation_angle'] as int,
        broadcast_type: json['broadcast_type'] as String,
        stringData: jsonEncode(jsonCopy));
  }

  Map toJson() {
    DebugPrint("LAYOUT DATA TO JSON CALLED");

    DebugPrint(message);

    if (message == "Live Broadcast") {
      return {
        "id": id,
        "name": name,
        "message": message,
        "current_datetime": currentDatetime,
        "updated_datetime": lastUpdatedAt,
        "start_datetime": startDateTime,
        "end_datetime": endDateTime,
        "orientation_angle": oreintationAngle,
        "zone_count": zoneCount,
        "zone_data": zoneData?.map((zone) => zone.toJson()).toList(),
      };
    } else {
      return {"message": "No other broadcast"};
    }
  }
}
