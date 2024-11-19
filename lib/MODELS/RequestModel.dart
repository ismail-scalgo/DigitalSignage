class RequestModel {
  String agentId;
  String name;
  String browser;
  String browserVersion;
  String location;
  String latitude;
  String longitude;
  String orientation;
  String platform;
  String osVersion;
  String height;
  String width;
  String type;
  RequestModel({
    required this.agentId,
    required this.name,
    required this.browser,
    required this.browserVersion,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.orientation,
    required this.platform,
    required this.osVersion,
    required this.height,
    required this.width,
    required this.type,
  });

  // factory Request.fromJson(Map<String, dynamic> json) {
  //   return Request(
  //     url: json['agent_id'],
  //     format: json['browser_used'],
  //     duration: json['browser_version'],
  //     url: json['agent_id'],
  //     format: json['browser_used'],
  //     duration: json['browser_version'],
  //     url: json['agent_id'],
  //     format: json['browser_used'],
  //     duration: json['browser_version'],
  //     url: json['agent_id'],
  //     format: json['browser_used'],
  //     duration: json['browser_version'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'agentId': agentId,
  //     'name': name,
  //     'browser': browser,
  //     'browserVersion': browserVersion,
  //     'location': location,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //     'orientation': orientation,
  //     'platform': platform,
  //     'osVersion': osVersion,
  //     'height': height,
  //     'width': width,
  //     'type': type,
  //   };
  // }

  Map<String, dynamic> toMap() {
    return {
      'agent_id': agentId,
      'name': name,
      'browser_used': browser,
      'browser_version': browserVersion,
      'location_address': location,
      'location_latitude': latitude,
      'location_longitude': longitude,
      'orientation_angle': orientation,
      'os': platform,
      'os_version': osVersion,
      'resolution_height': height,
      'resolution_width': width,
      'type': type,
    };
  }
}
