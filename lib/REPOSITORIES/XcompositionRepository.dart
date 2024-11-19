// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:digitalsignange/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/BroadCastModel.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LayoutRepository {
  Future<BroadCastModel?> newFetchData(String code) async {
    print("enteringggg");
    LayoutData? currentBroadcastData;
    LayoutData? nextBroadcastData;
    String data_url = '$BASEURL/api/launch-signage-screen/?code=$code';
    var response = await http.get(Uri.parse(data_url));
    // BroadCastModel? broadCastData;
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      String? screenStatus = jsonData["message"];
      print("data1 = ${jsonData["data"]["first_broadcast_data"]}");
      if (jsonData["data"]["first_broadcast_data"]['message'] ==
          "Live Broadcast") {
        currentBroadcastData =
            LayoutData.fromJson(jsonData["data"]["first_broadcast_data"]);
      } else {
        currentBroadcastData = null;
      }

      if (jsonData["data"]["second_broadcast_data"]['message'] ==
          "Live Broadcast") {
        nextBroadcastData =
            LayoutData.fromJson(jsonData["data"]["second_broadcast_data"]);
      } else {
        nextBroadcastData = null;
      }

      BroadCastModel broadCastData = BroadCastModel(
          message: screenStatus,
          currentBroadCast: currentBroadcastData,
          NextBroadCast: nextBroadcastData,
          layoutrespInString: response.body);

      // layoutdata.zoneData!.forEach((element) {
      //   element.compositionModels
      //       .removeWhere((content) => content.fileDuration == '0.0');
      // });
      return broadCastData;
    } else {
      print(" irresponse error");
      var jsonData = json.decode(response.body);
      log("message1 = ${jsonData["message"]}");
      // String screenStatus = jsonData["message"];
      BroadCastModel broadCastData = BroadCastModel(
        message: jsonData["message"],
        currentBroadCast: null,
        NextBroadCast: null,
      );
      return broadCastData;
    }
  }

  Future<BroadCastModel?> fetchDataFromStorage(String responce) async {
    LayoutData? currentBroadcastData;
    LayoutData? nextBroadcastData;

    // BroadCastModel? broadCastData;

    var jsonData = json.decode(responce);
    String? screenStatus = jsonData["message"];
    print("data1 = ${jsonData["data"]["first_broadcast_data"]}");
    if (jsonData["data"]["first_broadcast_data"]['message'] ==
        "Live Broadcast") {
      currentBroadcastData =
          LayoutData.fromJson(jsonData["data"]["first_broadcast_data"]);
    } else {
      currentBroadcastData = null;
    }

    if (jsonData["data"]["second_broadcast_data"]['message'] ==
        "Live Broadcast") {
      nextBroadcastData =
          LayoutData.fromJson(jsonData["data"]["second_broadcast_data"]);
    } else {
      nextBroadcastData = null;
    }

    BroadCastModel broadCastData = BroadCastModel(
        message: screenStatus,
        currentBroadCast: currentBroadcastData,
        NextBroadCast: nextBroadcastData,
        layoutrespInString: responce);

    // layoutdata.zoneData!.forEach((element) {
    //   element.compositionModels
    //       .removeWhere((content) => content.fileDuration == '0.0');
    // });
    return broadCastData;
  }
}
