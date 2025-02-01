// ignore_for_file: unused_import

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/LogModels.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogsRepository {
  Future<String?> sendLogs(List logs) async {
    String status;
    final apiUrl = '$BASEURL/api/screenlogs/';
    await http.post(Uri.parse(apiUrl), body: jsonEncode(logs));
  }
}
