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
      // zoneCount: json['zone_count'],
      zoneCount: 3,
      startTime: json['start_time'],
      endTime: json['end_time'],
      currentTime: json['current_datetime'],
      zoneData: (json['zone_data'] as List)
          .map((zone) => Zone.fromJson(zone))
          .toList(),
    );
  }
}

class ResponeReg {
  String? errMessage;
  RegisterResponse? response;

  ResponeReg({this.errMessage, this.response});

  factory ResponeReg.fromJson(Map<String, dynamic> json) {
    return ResponeReg(
      errMessage: json['message'],
      response: json['data'],
    );
  }
}

class RegisterResponse {
  int id;
  List<dynamic>? broadcasts;
  String? name;
  String? browser;
  String? browserVersion;
  String? location;
  String? latitude;
  String? longitude;
  String? orientation;
  String? platform;
  String? osVersion;
  String? height;
  String? width;
  String? type;
  String? code;
  String? isActive;
  String? user;
  // String? message;
  RegisterResponse({
    required this.id,
    this.broadcasts,
    this.name,
    this.browser,
    this.browserVersion,
    this.location,
    this.latitude,
    this.longitude,
    this.orientation,
    this.platform,
    this.osVersion,
    this.height,
    this.width,
    this.type,
    this.code,
    this.isActive,
    this.user,
    // this.message
  });
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'],
      name: json['browser_used'],
      browser: json['browser_used'],
      broadcasts: json['broadcasts'] as List,
      browserVersion: json['browser_version'],
      location: json['location_address'],
      latitude: json['location_latitude'],
      longitude: json['location_longitude'],
      orientation: json['orientation'],
      platform: json['os'],
      osVersion: json['os_version'],
      height: json['resolution_height'],
      width: json['resolution_width'],
      type: json['type'],
      code: json['code'],
      isActive: json['is_active'],
      user: json['user'],
      // message: json['message'],
    );
  }
}

// {
//   "data": {
//     "id": 29,
//     "broadcasts": [],
//     "resolution_width": 685,
//     "resolution_height": 1049,
//     "location_address": "Ginger, service line, Stationkadavu, Kazhakkoottam, Thiruvananthapuram, Kerala, 695001, India",
//     "os": "Android",
//     "browser_used": "Chrome",
//     "os_version": "windows-10",
//     "browser_version": "128.0.0.0",
//     "type": "Desktop",
//     "orientation": "landscape",
//     "location_latitude": "8.561087700000000",
//     "location_longitude": "76.877014900000000",
//     "name": "gdg",
//     "code": "O8ADX",
//     "is_active": false,
//     "user": 7
//   }
// }
