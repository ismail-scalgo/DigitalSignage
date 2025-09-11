// ignore_for_file: body_might_complete_normally_nullable

import 'package:player/Costants.dart';
import 'package:player/MODELS/ContentModel.dart';
import 'package:player/MODELS/RequestModel.dart';
import 'package:player/MODELS/ResponseDataModel.dart';
import 'package:player/MODELS/ScreenCodeModel.dart';
import 'package:player/MODELS/ZoneModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:player/Utils.dart';

class RegisterRepository {
  Future<String?> registerScreen(RequestModel request) async {
    // ResponeReg responseData = ResponeReg();
    String status;
    final apiUrl = '$BASEURL/api/signage-screen/';
    var response = await http.post(Uri.parse(apiUrl), body: request.toMap());
    DebugPrint("response data = ${response.statusCode}");
    // DebugPrint("body = ${response.body}");
    if (response.statusCode == 201) {
      DebugPrint("respose body = ${response.body}");
      status = "success";
      return status;
    } else {
      DebugPrint("error");
      final jsonData = json.decode(response.body);
      DebugPrint("error body = $jsonData");
      status = jsonData['message'];
      DebugPrint(jsonData['message']);
      throw Exception(status);
    }
  }

  Future<FetchScreenCodeModel?> fetchScreenCode(RequestModel request) async {
    DebugPrint("enteringggggggggggggg");
    String status;
    final apiUrl = '$BASEURL/api/generate-screen-code/';
    var req_body = request.toMap();

    DebugPrint(req_body);
    var response = await http.post(Uri.parse(apiUrl), body: req_body);
    DebugPrint("response data = ${response.statusCode}");
    DebugPrint("body = ${response.body}");
    DebugPrint("body = ${response}");
    if (response.statusCode == 201) {
      DebugPrint("respose body = ${response.body}");
      final jsonData = json.decode(response.body);
      return FetchScreenCodeModel(
          screenCode: jsonData["screen_code"],
          secretKey: jsonData["secret_key"]);
    } else {
      DebugPrint("error");
    }
  }

  Future<ScreenCodeModel?> checkScreenCode(String screenCode) async {
    ScreenCodeModel ScreenCodeResponse;
    DebugPrint("enteringggggggggggggg = $screenCode");
    // String status;
    final apiUrl = '$BASEURL/api/status-screen-code/?screen_code=$screenCode';

    var response = await http.get(Uri.parse(apiUrl));
    DebugPrint("response data = ${response.statusCode}");
    DebugPrint("body = ${response.body}");
    DebugPrint("body = ${response}");
    if (response.statusCode == 200) {
      DebugPrint("respose body = ${response.body}");
      final jsonData = json.decode(response.body);
      ScreenCodeResponse = ScreenCodeModel.fromJson(jsonData['data']);
      DebugPrint("code = $ScreenCodeResponse");
      return ScreenCodeResponse;
    } else {
      DebugPrint("error");
      DebugPrint("respose body = ${response.body}");
      final jsonData = json.decode(response.body);
      ScreenCodeResponse = ScreenCodeModel.fromJson(jsonData['data']);
      return ScreenCodeResponse;
    }
  }
}
