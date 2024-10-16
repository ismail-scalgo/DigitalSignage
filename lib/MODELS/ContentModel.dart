class Contents {
  String url;
  String format;
  String duration;
  Contents({required this.url, required this.format, required this.duration});

  factory Contents.fromJson(Map<String, dynamic> json) {
    return Contents(
      url: json['file_upload'],
      format: json['file_format'],
      duration: json['file_duration'],
    );
  }
}

class ScreenCodeModel {
  bool? isRegistered;
  String? message;
  String? agentId;
  ScreenCodeModel({this.isRegistered, this.message, this.agentId});

  factory ScreenCodeModel.fromJson(Map<String, dynamic> json) {
    return ScreenCodeModel(
      isRegistered: json['is_registered'],
      message: json['message'],
      agentId: json['agent_id'],
    );
  }
}
