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
