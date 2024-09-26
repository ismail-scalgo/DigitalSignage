// ignore_for_file: body_might_complete_normally_nullable

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/MODELS/ZoneModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginRepository {
  Future<String?> fetchLogin(String screenCode) async {
    String status;
    var responseData;
    final apiUrl = '$BASEURL/api/launch-signage-screen/?code=$screenCode';
    // final apiUrl = 'https://web-dev-sgdsignage.scalgo.net/api/launch-signage-screen/?code=$screenCode';
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      status = "success";
      return status;
    } else if (response.statusCode == 500) {
      status = "NoData";
      return status;
    } else {
      final jsonData = json.decode(response.body);
      status = jsonData['message'];
      print(jsonData['message']);
      throw Exception(status);
    }
  }
}
