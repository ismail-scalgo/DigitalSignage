class RequestModel {
  String agentId;
  String name;
  String? browser;
  String? browserVersion;
  String? location;
  double? latitude;
  double? longitude;
  String? orientation;
  String? platform;
  String? osVersion;
  double? height;
  double? width;
  String? type;
  RequestModel({
    required this.agentId,
    required this.name,
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

  Map<String, dynamic> toJson() {
    return {
      'agent_id': agentId,
      'name': name,
      'browser_used': browser,
      'browser_version': browserVersion,
      'location_address': location,
      'location_latitude': latitude,
      'location_longitude': longitude,
      'orientation': orientation,
      'os': platform,
      'os_version': osVersion,
      'resolution_height': height,
      'resolution_width': width,
      'type': type,
    };
  }
}
