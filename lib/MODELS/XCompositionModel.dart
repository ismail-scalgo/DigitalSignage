import 'dart:convert';

class CompositionModel {
  final String fileUrl;
  final String fileFormat;
  final String fileDuration;

  CompositionModel({
    required this.fileUrl,
    required this.fileFormat,
    required this.fileDuration,
  });

  // Convert JSON to CompositionModel
  factory CompositionModel.fromJson(Map<String, dynamic> json) {
    return CompositionModel(
      fileUrl: json['file_upload'] as String,
      fileFormat: json['file_format'] as String,
      fileDuration: json['duration'] as String,
    );
  }
}

class ZoneData {
  final int id;
  final String name;
  final int widthPercent;
  final int heightPercent;
  final int xPercent;
  final int yPercent;
  final List<CompositionModel> compositionModels;

  ZoneData({
    required this.id,
    required this.name,
    required this.widthPercent,
    required this.heightPercent,
    required this.xPercent,
    required this.yPercent,
    required this.compositionModels,
  });

  // Convert JSON to ZoneData
  factory ZoneData.fromJson(Map<String, dynamic> json) {
    var CompositionModelsJson = json['contents'] as List;
    List<CompositionModel> compositionModelsList =
        CompositionModelsJson.map((i) => CompositionModel.fromJson(i)).toList();

    return ZoneData(
      id: json['id'] as int,
      name: json['name'] as String,
      widthPercent: json['widthPercent'] as int,
      heightPercent: json['heightPercent'] as int,
      xPercent: json['xPercent'] as int,
      yPercent: json['yPercent'] as int,
      compositionModels: compositionModelsList,
    );
  }
}

class LayoutData {
  final int? id;
  final String? name;
  final String? message;
  String? currentDatetime;
  final String? startDateTime;
  final String? endDateTime;
  final int? zoneCount;
  final List<ZoneData>? zoneData;
  final int oreintationAngle;
  final String? lastUpdatedAt;
  String? stringData;

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
      this.stringData});

  // Convert JSON to LayoutData
  factory LayoutData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.from(json);
    jsonCopy.remove("current_datetime");
    print("from  layout");
    print(json['orientation_angle']);
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
        stringData: jsonEncode(jsonCopy));
  }
}
