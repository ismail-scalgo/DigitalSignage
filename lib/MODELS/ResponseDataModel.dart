import 'package:digitalsignange/MODELS/ZoneModel.dart';

class Data {
  String name;
  int zoneCount;
  String startTime;
  String endTime;
  String currentTime;
  List<Zone> zoneData;

  Data(
      {required this.name,
      required this.zoneCount,
      required this.zoneData,
      required this.startTime,
      required this.currentTime,
      required this.endTime});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'],
      zoneCount: json['zone_count'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      currentTime: json['current_time'],
      zoneData: (json['zone_data'] as List)
          .map((zone) => Zone.fromJson(zone))
          .toList(),
    );
  }
}
