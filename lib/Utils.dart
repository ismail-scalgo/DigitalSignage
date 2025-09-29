import 'package:flutter/services.dart';

void DebugPrint(Object? text) {
  print(text);
}

class PlatformTVCheck {
  static const MethodChannel _channel = MethodChannel('com.zignflix.player');

  static Future<bool> isTV() async {
    final bool isTV = await _channel.invokeMethod('isTV');
    DebugPrint("IS_TV");
    print(isTV);
    return isTV;
  }
}
