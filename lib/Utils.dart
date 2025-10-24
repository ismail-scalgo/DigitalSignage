import 'dart:math';

import 'package:flutter/services.dart';
import 'package:player/Costants.dart';

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

int calculateQuarterTurnsAndSave(int oreintationAngle) {
  print("CALCULATING_ORIENTATION_ANGLE");
  print(oreintationAngle);
  int quarterTurns = 0;

  if (oreintationAngle >= 0 && oreintationAngle < 90) {
    quarterTurns = 0;
  }

  if (oreintationAngle >= 90 && oreintationAngle < 180) {
    quarterTurns = 3;
  }

  if (oreintationAngle >= 180 && oreintationAngle < 270) {
    quarterTurns = 2;
  }

  if (oreintationAngle >= 270 && oreintationAngle < 360) {
    quarterTurns = 1;
  }

  QUARTER_TURNS = quarterTurns;

  return quarterTurns;
}

int generateRandomNumber()
{

   return Random().nextInt(1000);
}
