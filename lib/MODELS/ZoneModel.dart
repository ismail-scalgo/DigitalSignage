import 'package:digitalsignange/MODELS/ContentModel.dart';

class Zone {
  int id;
  String name;
  int x;
  int y;
  int width;
  int height;
  List<Contents> contents;

  Zone(
      {required this.id,
      required this.name,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      required this.contents});

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'],
      name: json['name'],
      x: json['xPercent'],
      y: json['yPercent'],
      width: json['widthPercent'],
      height: json['heightPercent'],
      contents: (json['contents'] as List)
          .map((content) => Contents.fromJson(content))
          .toList(),
    );
  }
}
