import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/UI/LaunchingScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenCodeScreen extends StatefulWidget {
  const ScreenCodeScreen({super.key});

  @override
  State<ScreenCodeScreen> createState() => _ScreenCodeScreenState();
}

class _ScreenCodeScreenState extends State<ScreenCodeScreen> {
  late RegisterblocBloc registerBloc;
  late String platform;
  late RequestModel request;

  @override
  void initState() {
    super.initState();
    registerBloc = BlocProvider.of<RegisterblocBloc>(context);
    checkScreenCode();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: BlocConsumer<RegisterblocBloc, RegisterblocState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is LaunchScreen) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LaunchingScreen(screenCode: state.code)),
                (route) => false);
          }
        },
        builder: (context, state) {
          if (state is DisplayNewScreenCode) {
            setNewScreenCode(state.screenCode);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  colors: [
                    Color.fromARGB(255, 86, 0, 224),
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0)
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
                  Container(
                    // color: Colors.white,
                    height: height / 1.2,
                    width: width / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pair device",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "1,  Login to your Digital Signage account at www.web-sgdsg.com",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "2,  Select New Screen and enter this code in the popup",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          state.screenCode,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is DisplayOldScreenCode) {
            // setNewScreenCode(state.screenCode);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  colors: [
                    Color.fromARGB(255, 86, 0, 224),
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0)
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
                  Container(
                    // color: Colors.white,
                    height: height / 1.2,
                    width: width / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pair device",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "1,  Login to your Digital Signage account at www.web-sgdsg.com",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "2,  Select New Screen and enter this code in the popup",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          state.screenCode,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            width: width,
            height: height,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      )),
    );
  }

  void checkScreenCode() async {
    // registerBloc.add(DisplayScreenCode(screenCode: "M40L20"));
    // registerBloc.add(DisplayScreenCode(screenCode: "M40L50"));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('NewScreenCode');
    // prefs.remove('isRegistered');
    // await prefs.setString('NewScreenCode', "TBE6BF");
    // await prefs.setBool('isRegistered', true);
    String? screenCode = prefs.getString('NewScreenCode');
    bool? isRegistered = prefs.getBool('isRegistered');
    if (isRegistered == null) {
      isRegistered = false;
    }
    print("code = $screenCode");
    print("register = $isRegistered");

    // screenCode = "3K1NQO";

    if (screenCode == null) {
      print("null code");
      requestScreenCode();
    } else if (screenCode != null && !isRegistered!) {
      registerBloc.add(DisplayScreenCode(screenCode: screenCode));
    } else if (screenCode != null && isRegistered!) {
      print("got it");
      registerBloc.add(LaunchSignage(screenCode: screenCode));
    }
    // print("code = ${prefs.getString('screenCode')}");
  }

  void setNewScreenCode(String screenCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('NewScreenCode', screenCode);
    await prefs.setBool('isRegistered', false);
    // registerBloc.add(ConnectSocket(screenCode: screenCode));
  }

  // void validateScreencode(String screenCode) {
  //   registerBloc.add(GetScreenCode(request: request));
  // }

  void requestScreenCode() async {
    // var currentPlatform = await initPlatformState();
    request = RequestModel(
        // platform: currentPlatform,
        width: MediaQuery.of(context).size.width.toInt().toString(),
        height: MediaQuery.of(context).size.height.toInt().toString());
    print("adding event");
    registerBloc.add(GetScreenCode(request: request));
  }

  // Future<String> initPlatformState() async {
  //   var deviceData = <String, dynamic>{};
  //   try {
  //     if (kIsWeb) {
  //       deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
  //       // print(deviceData);
  //       // print("platform = ${deviceData['platform']}");
  //       // platform = deviceData['platform'];
  //       // request.platform = platform;
  //       PLATFORM = deviceData['platform'];
  //       return deviceData['platform'];
  //     } else {
  //       if (Platform.isAndroid) {
  //         platform = 'Android';
  //         PLATFORM = 'Android';
  //       } else if (Platform.isIOS) {
  //         platform = 'iOS';
  //         PLATFORM = 'iOS';
  //       } else if (Platform.isWindows) {
  //         platform = 'Windows';
  //         PLATFORM = 'Windows';
  //       } else if (Platform.isLinux) {
  //         platform = 'Linux';
  //         PLATFORM = 'Linux';
  //       } else if (Platform.isMacOS) {
  //         platform = 'macOS';
  //         PLATFORM = 'macOS';
  //       } else {
  //         platform = 'Unknown';
  //         PLATFORM = 'Unknown';
  //       }
  //       // print("platform = $platform");
  //       // request.platform = platform;
  //       return PLATFORM;
  //     }
  //   } on PlatformException {
  //     // deviceData['platform'] = "Unknown";
  //     PLATFORM = 'Unknown';
  //     // deviceData = <String, dynamic>{
  //     //   'Error:': 'Failed to get platform version.'
  //     // };
  //   }
  //   if (!mounted) PLATFORM = 'Unknown';
  //   // setState(() {
  //   //   deviceData = deviceData;
  //   //   // print("platform = ${deviceData}");
  //   // });
  //   return platform;
  // }

  // Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  //   return <String, dynamic>{
  //     'browserName': data.browserName.name,
  //     'appCodeName': data.appCodeName,
  //     'appName': data.appName,
  //     'appVersion': data.appVersion,
  //     'deviceMemory': data.deviceMemory,
  //     'language': data.language,
  //     'languages': data.languages,
  //     'platform': data.platform,
  //     'product': data.product,
  //     'productSub': data.productSub,
  //     'userAgent': data.userAgent,
  //     'vendor': data.vendor,
  //     'vendorSub': data.vendorSub,
  //     'hardwareConcurrency': data.hardwareConcurrency,
  //     'maxTouchPoints': data.maxTouchPoints,
  //   };
  // }
}
