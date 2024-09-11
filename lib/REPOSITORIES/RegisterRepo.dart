// ignore_for_file: body_might_complete_normally_nullable

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/MODELS/ZoneModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterRepository {
  Future<String?> registerScreen(RequestModel request) async {
    // ResponeReg responseData = ResponeReg();
    String status;
    final apiUrl = 'https://web-dev-sgdsignage.scalgo.net/api/signage-screen/';

    // print("request = ${request.name}");
    // print("request = ${request.agentId}");
    // print("request = ${request.browser}");
    // print("request = ${request.browserVersion}");
    // print("request = ${request.height}");
    // print("request = ${request.width}");
    // print("request = ${request.latitude}");
    // print("request = ${request.longitude}");
    // print("request = ${request.location}");
    // print("request = ${request.orientation}");
    // print("request = ${request.osVersion}");
    // print("request = ${request.platform}");
    // print("request = ${request.type}");
    // Map newMap = {
    //   "agent_id" : request.agentId,
    //   "name" : request.name,
    //   "browser_used" : request.browser,
    //   "browser_version" : request.browserVersion,
    //   "location_address" : request.location,
    //   "location_latitude" :request.latitude,
    //   "location_longitude" : request.longitude,
    //   "orientation" : request.orientation,
    //   "os" : request.platform,
    //   "os_version" : request.osVersion,
    //   "resolution_height" : request.height,
    //   "resolution_width" : request.width,
    //   "type" : request.name,
    //   };
    var response = await http.post(Uri.parse(apiUrl), body: request.toMap());
    print("response data = ${response.statusCode}");
    // print("body = ${response.body}");
    if (response.statusCode == 201) {
      // print("response data = ${response.body}");
      // final jsonData = json.decode(response.body);
      // print("getting");
      // responseData.response = RegisterResponse.fromJson(jsonData["data"]);
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
}

// "error body = {os_version: [Ensure this field has no more than 100 characters.]}"
// "error body = {message: Agent ID doesn't exist}"
