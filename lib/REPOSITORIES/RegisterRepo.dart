// ignore_for_file: body_might_complete_normally_nullable

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/MODELS/ZoneModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterRepository {
  Future<Data?> registerScreen(RequestModel request) async {
    // late Data responseData;
    // final apiUrl = 'https://web-dev-sgdsignage.scalgo.net/api/signage-screen/';
    // var response = await http.post(Uri.parse(apiUrl), body: request);

    // 'http://192.168.0.92:8000/api/launch-signage-screen/?code=FQVNJ'));

    // // print("response data = ${response.body}");
    // print("response data = ${response.statusCode}");
    // if (response.statusCode == 200) {
    //   final jsonData = json.decode(response.body);

    //   responseData = Data.fromJson(jsonData["data"]);
    //   print("response data = ${responseData}");
    //   return responseData;
    // } else {
    //   print("Error");
    // }
    // return Data(name: name, zoneCount: zoneCount, zoneData: zoneData);
  }
}
