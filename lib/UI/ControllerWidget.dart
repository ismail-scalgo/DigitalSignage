import 'package:digitalsignange/UI/LaunchingScreen.dart';
import 'package:digitalsignange/UI/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControllerWidget extends StatefulWidget {
  const ControllerWidget({super.key});

  @override
  State<ControllerWidget> createState() => _ControllerWidgetState();
}

class _ControllerWidgetState extends State<ControllerWidget> {
  String? screenCode;
  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    getScreenCode();
    print("code = $screenCode");
  }

  @override
  Widget build(BuildContext context) {
    print("screencode = $screenCode");
    return isLoad
        ? Center(child: Lottie.asset('assets/Shoes.json'))
        : (screenCode != null
            ? LaunchingScreen(screenCode: screenCode!)
            : LoginScreen());
  }

  void getScreenCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    screenCode = prefs.getString('screenCode');
    setState(() {
      isLoad = false;
    });
  }
}
