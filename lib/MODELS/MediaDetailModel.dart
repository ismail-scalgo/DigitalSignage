import 'package:digitalsignange/MODELS/ContentModel.dart';

class MediaDetails {
  int id;
  int height;
  int width;
  int currentMediaPosition;
  int currentDurationCount;
  List<Contents> contentsList;
  MediaDetails({
    required this.id,
    required this.height,
    required this.width,
    required this.currentMediaPosition,
    required this.currentDurationCount,
    required this.contentsList,
  });
}
