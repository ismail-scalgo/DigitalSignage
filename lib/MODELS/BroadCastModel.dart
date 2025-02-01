// ignore_for_file: non_constant_identifier_names
import 'package:digitalsignange/MODELS/XCompositionModel.dart';

class BroadCastModel {
  String? message;
  LayoutData? currentBroadCast;
  LayoutData? NextBroadCast;
  String? layoutrespInString;
  BroadCastModel(
      {this.currentBroadCast,
      this.NextBroadCast,
      this.message,
      this.layoutrespInString});

  Map toJsonBroadCastModel() {
    return {
      "data": {
        "first_broadcast_data": currentBroadCast == null
            ? {"message": "No other broadcast"}
            : currentBroadCast?.toJson(),
        "second_broadcast_data": NextBroadCast == null
            ? {"message": "No other broadcast"}
            : NextBroadCast?.toJson(),
        "message": message
      }
    };
  }
}
