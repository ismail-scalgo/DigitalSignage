import 'dart:async';

import 'package:digitalsignange/REPOSITORIES/LogRepository.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool ISFIRST_LAUNCH = true;
late Box box;
late SharedPreferences prefs;
String? screenCode = prefs.getString('NewScreenCode');

Future log_of_start_stop() async {
  prefs = await SharedPreferences.getInstance();

  bool connection_result = await InternetConnection().hasInternetAccess;
  box = await Hive.openBox("start_stop_db");
  var datas = box.keys;

  if (connection_result) {
    await sync_data_to_server_onLaunch();
  }

  //WITH  INTERNET CONNECTION
  if (connection_result) {
    //  NO LOGS THAT IS VERY FIRST LOGIN
    if (datas.length == 0) {
      //UPDATE START TIME TO SERVER

      log_save_start_time_and_start_stop(hasInternetAccess: connection_result);
    } else {
      //UPDATE SAVED LOG TO SERVER
      await log_clear_all_log();
      //UPDATE START TIME TO SERVER

      log_save_start_time_and_start_stop(hasInternetAccess: connection_result);
    }
  }
  // WITHOUT INTERNET CONNECTION
  else {
    DateTime dateTime = DateTime.now();

    log_save_start_time_and_start_stop(hasInternetAccess: connection_result);
  }
}

Future log_clear_all_log() async {
  await box.clear();
}

void log_save_start_time_and_start_stop(
    {required bool hasInternetAccess}) async {
  var datas = box.keys;
  if (datas.length == 0) {
    if (hasInternetAccess) {
      DateTime dateTime = DateTime.now();
      update_to_server([
        {
          "action_at": dateTime.toString(),
          'action': 'application_launch',
          'screen_code': screenCode
        }
      ]);
      log_save_stop_time(1, box);
    } else {
      DateTime dateTime = DateTime.now();
      box.put(1, {
        "action_at": dateTime.toString(),
        'action': 'application_launch',
        'screen_code': screenCode
      });
      log_save_stop_time(1, box);
    }
  } else {
    int key = datas.length;
    key = key + 2;
    DateTime dateTime = DateTime.now();
    box.put(key, {
      "action_at": dateTime.toString(),
      'action': 'application_launch',
      'screen_code': screenCode
    });
    log_save_stop_time(key, box);
  }
}

void log_save_stop_time(int key, Box box) async {
  DateTime dateTime = DateTime.now().add(Duration(seconds: 30));
  box.put(key + 1, {
    "action_at": dateTime.toString(),
    'action': 'application_exit',
    'screen_code': screenCode
  });
  Timer.periodic(Duration(seconds: 30), (timer) {
    DateTime dateTime = DateTime.now().add(Duration(seconds: 30));
    box.put(key + 1, {
      "action_at": dateTime.toString(),
      'action': 'application_exit',
      'screen_code': screenCode
    });
  });
}

void log_start_broadcast(int id) async {
  bool connection_result = await InternetConnection().hasInternetAccess;
  DateTime dateTime = DateTime.now();

  if (connection_result) {
    update_to_server([
      {
        "action_at": dateTime.toString(),
        'action': 'broadcast_start',
        'broadcast_id': id,
        'screen_code': screenCode
      }
    ]);
  } else {
    var datas = box.keys;
    int key = datas.length;
    key = key + 2;
    box.put(key + 1, {
      "action_at": dateTime.toString(),
      'action': 'broadcast_start',
      'broadcast_id': id,
      'screen_code': screenCode
    });
  }
}

void log_end_broadcast(int id) async {
  bool connection_result = await InternetConnection().hasInternetAccess;
  DateTime dateTime = DateTime.now();

  if (connection_result) {
    update_to_server([
      {
        "action_at": dateTime.toString(),
        'action': 'broadcast_end',
        'broadcast_id': id,
        'screen_code': screenCode
      }
    ]);
  } else {
    var datas = box.keys;
    int key = datas.length;
    key = key + 2;

    box.put(key + 1, {
      "action_at": dateTime.toString(),
      'action': 'broadcast_end',
      'broadcast_id': id,
      'screen_code': screenCode
    });
  }
}

Future sync_data_to_server_when_online() async {
  var logs = box.values;
  Map last_exit_time = {};
  List datalist = logs.toList();
  print("logs1  = $datalist");
  if (datalist.length > 1) {
    int last_exit_time_index = -1;
    Map last_application_exit = {};
    for (int i = 0; i < datalist.length; i++) {
      if ((datalist[i] as Map).containsValue("application_exit")) {
        last_exit_time_index = i;
        last_application_exit = datalist[i];
      }
    }
    if (last_exit_time_index > -1) {
      datalist.removeAt(last_exit_time_index);
      print("logs2  = $datalist");
      final LogsRepository logRepo = LogsRepository();
      logRepo.sendLogs(datalist);
      box.clear();
      box.put(1, last_application_exit);
    }
  }
}

Future sync_data_to_server_onLaunch() async {
  var logs = box.values;
  List datalist = logs.toList();
  print("datalist = $datalist");
  if (datalist.length > 0) {
    update_to_server(datalist);
    await box.clear();
  }
  print("LOGGGGGGGGGGGGGG");
  // Timer.periodic(Duration(seconds: 30), (time) {
  //   var logs = box.values;

  //   List datalist = logs.toList();
  //   print("LOGGGGGGGGGGGGGG");
  //   print(datalist);
  // });
}

Future update_to_server(List updatelist) async {
  print("list = $updatelist");
  print("server updating");
  final LogsRepository logRepo = LogsRepository();
  logRepo.sendLogs(updatelist);
}
