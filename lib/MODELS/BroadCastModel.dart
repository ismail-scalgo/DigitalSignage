// ignore_for_file: non_constant_identifier_names
import 'package:player/MODELS/XCompositionModel.dart';

class BroadCastModel {
  String? message;
  LayoutData? currentBroadCast;
  LayoutData? NextBroadCast;
  String? layoutrespInString;
  int? screen_orientation;

  BroadCastModel(
      {this.currentBroadCast,
      this.NextBroadCast,
      this.message,
      this.layoutrespInString,
      this.screen_orientation
      });

  Map toJsonBroadCastModel() {
    return {
      "data": {
        "first_broadcast_data": currentBroadCast == null
            ? {"message": "No other broadcast"}
            : currentBroadCast?.toJson(),
        "second_broadcast_data": NextBroadCast == null
            ? {"message": "No other broadcast"}
            : NextBroadCast?.toJson(),
            "orientation_angle":screen_orientation == null ? 0 : screen_orientation,
        "message": message
      }
    };
  }
}
