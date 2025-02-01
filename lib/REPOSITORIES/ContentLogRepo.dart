import 'package:digitalsignange/Costants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ContentLogsRepository {
  Future<String?> sendContentLogs(Map logs) async {

    const Map<String, String> header = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

    final apiUrl = BASEURL + '/api/content-logs/';

// Map data={"screen_code":"65QMZE","broadcast_id":"15","broadcast_start_datetime":"2023-12-03T10:00:00Z","broadcast_end_datetime":"2023-12-03T10:00:00Z","content_history":
// [{"content_name":"peacock","content_duration":120.0},{"content_name":"dove","content_duration":112.0}]};

   var response= await http.post(Uri.parse(apiUrl), body:jsonEncode(logs),headers: header);
   print("RESPONCE+++${response.body}");
  }
}
