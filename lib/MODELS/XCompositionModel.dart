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
  final String name;
  final String currentDatetime;
  final String startDateTime;
  final String endDateTime;
  final int zoneCount;
  final List<ZoneData> zoneData;
  final int oreintation_angle;
  final String last_updatedat;

  LayoutData(
      {required this.name,
      required this.currentDatetime,
      required this.startDateTime,
      required this.endDateTime,
      required this.zoneCount,
      required this.zoneData,
      required this.oreintation_angle,
      required this.last_updatedat});

  // Convert JSON to LayoutData
  factory LayoutData.fromJson(Map<String, dynamic> json) {
    print("from  layout");
    print(json['orientation_angle']);
    var zoneDataJson = json['zone_data'] as List;
    List<ZoneData> zoneDataList =
        zoneDataJson.map((i) => ZoneData.fromJson(i)).toList();

    return LayoutData(
      name: json['name'] as String,
      currentDatetime: json['current_datetime'] as String,
      startDateTime: json['start_time'] as String,
      endDateTime: json['end_time'] as String,
      zoneCount: json['zone_count'] as int,
      zoneData: zoneDataList,
      last_updatedat: json['updated_time'],
      oreintation_angle: json['orientation_angle'] as int,
    );
  }
}
