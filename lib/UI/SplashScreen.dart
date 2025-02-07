// ignore_for_file: use_build_context_synchronously

import 'package:digitalsignange/UI/AutoStartPermissionScreen.dart';
import 'package:digitalsignange/UI/ScreenCodeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // nextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: width > height ? height / 20 : width / 20,
                  width: width > height ? width / 11.5 : height / 11.5,
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 136, 130, 130),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Color.fromARGB(255, 19, 220, 255).withAlpha(60),
                      //   blurRadius: 10,
                      //   spreadRadius: 5,
                      //   offset: const Offset(
                      //     0.0,
                      //     3.0,
                      //   ),
                      // ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "DIGITAL",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              width > height ? width / 48 : height / 48), //28
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "SIGNAGE",
                  style: TextStyle(
                      color: Color.fromARGB(255, 136, 130, 130),
                      // fontWeight: FontWeight.bold,
                      fontSize: width > height ? width / 60 : height / 60), //28
                  // glowColor: Color.fromARGB(255, 38, 216, 223),
                  // blurRadius: 8,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  void nextScreen() async {
    await Future.delayed(Duration(seconds: 4));
    print("TIME PERIOD COMPLETED");

   

    if (await Permission.systemAlertWindow.isGranted) {

        FlutterNativeSplash.remove();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AutoStartPermissionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(seconds: 2),
        ),
      );


     
    } else {

       FlutterNativeSplash.remove();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ScreenCodeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(seconds: 2),
        ),
      );
      
    }

  }

  
}


