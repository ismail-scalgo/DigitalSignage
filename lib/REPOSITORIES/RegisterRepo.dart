// ignore_for_file: body_might_complete_normally_nullable

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/ContentModel.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/MODELS/ZoneModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterRepository {
  Future<String?> registerScreen(RequestModel request) async {
    // ResponeReg responseData = ResponeReg();
    String status;
    final apiUrl = '$BASEURL/api/signage-screen/';
    var response = await http.post(Uri.parse(apiUrl), body: request.toMap());
    print("response data = ${response.statusCode}");
    // print("body = ${response.body}");
    if (response.statusCode == 201) {
      print("respose body = ${response.body}");
      status = "success";
      return status;
    } else {
      print("error");
      final jsonData = json.decode(response.body);
      print("error body = $jsonData");
      status = jsonData['message'];
      print(jsonData['message']);
      throw Exception(status);
    }
  }

  Future<String?> fetchScreenCode(RequestModel request) async {
    // ResponeReg responseData = ResponeReg();
    print("enteringggggggggggggg");
    String status;
    final apiUrl = '$BASEURL/api/generate-screen-code/';
    var response = await http.post(Uri.parse(apiUrl), body: request.toMap());
    print("response data = ${response.statusCode}");
    print("body = ${response.body}");
    print("body = ${response}");
    if (response.statusCode == 201) {
      print("respose body = ${response.body}");
      final jsonData = json.decode(response.body);
      // screen_code
      // status = "success";
      return jsonData["screen_code"];
    } else {
      print("error");
      // final jsonData = json.decode(response.body);
      // print("error body = $jsonData");
      // status = jsonData['message'];
      // print(jsonData['message']);
      // throw Exception(status);
    }
  }

  Future<ScreenCodeModel?> checkScreenCode(String screenCode) async {
    ScreenCodeModel ScreenCodeResponse;
    print("enteringggggggggggggg = $screenCode");
    // String status;
    final apiUrl = '$BASEURL/api/status-screen-code/?screen_code=$screenCode';

    var response = await http.get(Uri.parse(apiUrl));
    print("response data = ${response.statusCode}");
    print("body = ${response.body}");
    print("body = ${response}");
    if (response.statusCode == 200) {
      print("respose body = ${response.body}");
      final jsonData = json.decode(response.body);
      ScreenCodeResponse = ScreenCodeModel.fromJson(jsonData['data']);
      print("code = $ScreenCodeResponse");
      return ScreenCodeResponse;
    } else {
      print("error");
      print("respose body = ${response.body}");
      final jsonData = json.decode(response.body);
      ScreenCodeResponse = ScreenCodeModel.fromJson(jsonData['data']);
      return ScreenCodeResponse;
    }
  }
}
