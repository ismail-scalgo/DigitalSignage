import 'package:player/UI/ScreenCodeScreen.dart';
import 'package:fire_tv_listener/fire_tv_listener.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

class AutoStartPermissionScreen extends StatefulWidget {
  @override
  State<AutoStartPermissionScreen> createState() =>
      _AutoStartPermissionScreenState();
}

class _AutoStartPermissionScreenState extends State<AutoStartPermissionScreen>
    with WidgetsBindingObserver {
  bool returnedFromSettings = false;

  late double height;
  late double width;
    final fn = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Permission.systemAlertWindow.isGranted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PreScreenCodeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(seconds: 2),
          ),
        );

        //navigate to screen
        print("NAVIGATEDD   TO  SCREEN");
      }

      // App returned to foreground (from settings)
      // setState(() {
      //   returnedFromSettings = true;
      // });
      print("Returned from settings");
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
   
    return Scaffold(
      //  appBar: AppBar(title: Text('Home Page')),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //         onPressed: requestOverlayPermission,
      //         child: Text('Open Settings'),
      //       ),
      //       SizedBox(height: 20),
      //       Text(
      //         returnedFromSettings ? 'Returned from Settings' : 'Go to Settings',
      //         style: TextStyle(fontSize: 18),
      //       ),
      //     ],
      //   ),
      // ),

      body: permissionScreen(),
    );
  }

  void requestOverlayPermission() async {
    if (!await Permission.systemAlertWindow.isGranted) {
      final intent = AndroidIntent(
        action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
        data: 'package:your.package.name',
      );
      await intent.launch();
    }
  }

  Widget permissionScreen() {
    return FireTVRemoteListener(
      focusNode: fn,
        onUp: () {
           Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PreScreenCodeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(seconds: 2),
          ),
        );

        },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // transform: GradientRotation(0.3),
            tileMode: TileMode.mirror,
            colors: [
              Color.fromARGB(255, 43, 2, 109),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 43, 2, 109),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 15,
            ),
            Container(
              // color: Colors.white,
              height: height / 1.2,
              width: width / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Allow overlay permission for auto launching of app on reboot",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 190, 190, 190),
                        fontSize: 20,
                        // fontSize: width / 50,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        requestOverlayPermission();
                      },
                      child: Text("GO TO SETTINGS"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
