// ignore_for_file: prefer_const_constructors, unused_import, use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/UI/LoginScreen.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:digitalsignange/MODELS/RequestModel.dart';
import 'package:digitalsignange/UI/newUi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:platform_detector/enums.dart';
import 'dart:convert';
import 'package:platform_detector/platform_detector.dart';

import 'package:toastification/toastification.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final screenNameController = TextEditingController();
  final agentIdController = TextEditingController();
  late RegisterblocBloc registerBloc;
  String? screenError;
  String? agentError;
  late String platform;
  late RequestModel request;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    registerBloc = BlocProvider.of<RegisterblocBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // print(Platform.isAndroid);
    // print("height = $height");
    // print("width = $width");
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [
                Color.fromARGB(255, 223, 124, 124),
                Color.fromARGB(255, 28, 91, 128)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height / 1.5,
                width: width / 1.7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    tileMode: TileMode.mirror,
                    colors: [
                      Color.fromARGB(255, 212, 135, 135),
                      Color.fromARGB(255, 0, 69, 109)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  color: Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: Text("Enter details to register your screen",
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.normal,
                    //         color: Colors.white
                    //       )),
                    // ),
                    BlocConsumer<RegisterblocBloc, RegisterblocState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 50, right: 50),
                              child: TextField(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 209, 209, 209)),
                                controller: screenNameController,
                                decoration: InputDecoration(
                                  labelText: 'Screen Name',
                                  errorText: state.nameErr,
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 209, 209, 209)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 209, 209, 209)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 209, 209, 209)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 50, right: 50),
                              child: TextField(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 209, 209, 209)),
                                controller: agentIdController,
                                decoration: InputDecoration(
                                  labelText: "Agent Id",
                                  errorText: state.agentIdErr,
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 209, 209, 209)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 209, 209, 209)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 209, 209, 209)),
                                  ),
                                  // labelStyle: TextStyle(color: Colors.blue)
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: InkWell(
                        child: Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              tileMode: TileMode.mirror,
                              colors: [
                                Color.fromARGB(255, 230, 163, 163),
                                Color.fromARGB(255, 6, 104, 160)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        onTap: () async {
                          // var location = await _determinePosition();
                          var currentPlatform = await initPlatformState();
                          // var address = await fetchResponse(
                          //     location.latitude, location.longitude);
                          request = RequestModel(
                              agentId: agentIdController.text,
                              name: screenNameController.text,
                              platform: currentPlatform,
                              // location: address,
                              // latitude: location.latitude,
                              // longitude: location.longitude,
                              width: width.toInt().toString(),
                              height: height.toInt().toString());
                          validateInput(request);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        hoverColor: const Color.fromARGB(255, 224, 224, 224),
                        onTap: () {
                          launchSignageClicked();
                        },
                        child: Text("Launch Signage",
                            style: TextStyle(
                              color: Color.fromARGB(255, 209, 209, 209),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ),
                    BlocConsumer<RegisterblocBloc, RegisterblocState>(
                      // buildWhen: (previous, current) {
                      // },
                      listener: (context, state) {
                        if (state is SignInScreen) {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        }
                        if (state is SuccessState) {
                          showToast(context, "Successfully Registered");
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          });
                        }
                        if (state is FailureState) {
                          print("failingg.");
                          showToast(context, state.message);
                        }
                        if (state is PermissionDenied) {
                          showToast(context, state.message);
                        }
                      },
                      builder: (context, state) {
                        // if (state is LaunchScreen) {
                        //   return Center();
                        // }
                        return Center();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void validateInput(RequestModel requestData) async {
    if (await isOffline()) {
      showToast(context, "No Internet Connection");
      return;
    }
    registerBloc.add(RegisterUser(request: request));
  }

  Future<String> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
        // print(deviceData);
        // print("platform = ${deviceData['platform']}");
        // platform = deviceData['platform'];
        // request.platform = platform;
        PLATFORM = deviceData['platform'];
        return deviceData['platform'];
      } else {
        if (Platform.isAndroid) {
          platform = 'Android';
          PLATFORM = 'Android';
        } else if (Platform.isIOS) {
          platform = 'iOS';
          PLATFORM = 'iOS';
        } else if (Platform.isWindows) {
          platform = 'Windows';
          PLATFORM = 'Windows';
        } else if (Platform.isLinux) {
          platform = 'Linux';
          PLATFORM = 'Linux';
        } else if (Platform.isMacOS) {
          platform = 'macOS';
          PLATFORM = 'macOS';
        } else {
          platform = 'Unknown';
          PLATFORM = 'Unknown';
        }
        // print("platform = $platform");
        // request.platform = platform;
        return PLATFORM;
      }
    } on PlatformException {
      // deviceData['platform'] = "Unknown";
      PLATFORM = 'Unknown';
      // deviceData = <String, dynamic>{
      //   'Error:': 'Failed to get platform version.'
      // };
    }
    if (!mounted) PLATFORM = 'Unknown';
    // setState(() {
    //   deviceData = deviceData;
    //   // print("platform = ${deviceData}");
    // });
    return platform;
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  void showToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      backgroundColor: Color.fromARGB(255, 212, 135, 135),
      foregroundColor: Colors.white,
      type: ToastificationType.success,
      style: ToastificationStyle.simple,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void launchSignageClicked() async {
    if (await isOffline()) {
      showToast(context, "No Internet Connection");
      return;
    }
    registerBloc.add(ShowSignIn());
  }
}
