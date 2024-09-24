// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

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
import 'package:lottie/lottie.dart';
import 'package:platform_detector/enums.dart';
import 'dart:convert';
import 'package:platform_detector/platform_detector.dart';

import 'package:toastification/toastification.dart';

class Registerscreen3 extends StatefulWidget {
  const Registerscreen3({super.key});

  @override
  State<Registerscreen3> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Registerscreen3> {
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
  Widget build(BuildContext context1) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [
                Color.fromARGB(255, 215, 227, 255),
                Color.fromARGB(255, 143, 174, 243)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          // color: Color.fromARGB(255, 143, 174, 243),
          height: height,
          width: width,
          child: Center(
            child: Container(
              width: width / 1.3,
              height: height / 1.3,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 20),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 131, 154, 255),
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
                                Container(
                                  width: width / 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40, left: 50, right: 50),
                                    child: TextField(
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 58, 85, 206)),
                                      controller: screenNameController,
                                      decoration: InputDecoration(
                                          labelText: 'Screen name',
                                          errorText: state.nameErr,
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 131, 154, 255)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 131, 154, 255)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 131, 154, 255)),
                                          ),
                                          focusColor: Color.fromARGB(
                                              255, 131, 154, 255),
                                          // errorBorder: UnderlineInputBorder(),
                                          errorStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 58, 85, 206))),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width / 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 50, right: 50),
                                    child: TextField(
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 58, 85, 206)),
                                      controller: agentIdController,
                                      decoration: InputDecoration(
                                          labelText: 'Agent Id',
                                          errorText: state.agentIdErr,
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 131, 154, 255)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 131, 154, 255)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 131, 154, 255)),
                                          ),
                                          focusColor: Color.fromARGB(
                                              255, 131, 154, 255),
                                          errorBorder: UnderlineInputBorder(),
                                          errorStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 58, 85, 206))),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: InkWell(
                            child: Container(
                              height: 35,
                              width: width / 5.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 143, 174, 243)),
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
                            hoverColor:
                                const Color.fromARGB(255, 224, 224, 224),
                            onTap: () {
                              launchSignageClicked();
                            },
                            child: Container(
                              width: width / 5,
                              child: Center(
                                child: Text("Launch Signage",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 131, 154, 255),
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
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
                              Navigator.pop(context);
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
                              Navigator.pop(context);
                              showToast(context, state.message);
                            }
                            if (state is PermissionDenied) {
                              Navigator.pop(context);
                              showToast(context, state.message);
                            }
                            if (state is LoadingState) {
                              showMyDialog(context);
                            }
                          },
                          builder: (context, state) {
                            return Center();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            // color: Color.fromARGB(255, 54, 104, 212),
                            borderRadius: BorderRadius.circular(15)),
                        child: Lottie.asset('assets/Profiles.json'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     // ],
          //     Container(
          //       height: height / 2,
          //       width: width / 1,
          //       // decoration: BoxDecoration(
          //       //   gradient: LinearGradient(
          //       //     tileMode: TileMode.mirror,
          //       //     colors: [
          //       //       Color.fromARGB(255, 212, 135, 135),
          //       //       Color.fromARGB(255, 0, 69, 109)
          //       //     ],
          //       //     begin: Alignment.topCenter,
          //       //     end: Alignment.bottomCenter,
          //       //   ),
          //       //   color: Color.fromARGB(255, 224, 224, 224),
          //       //   borderRadius: BorderRadius.circular(15),
          //       // ),
          //       child: Lottie.asset('assets/loginAnim.json'),
          //     ),
          //     Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           // Container(
          //           //   child: Lottie.asset('assets/loginAnim.json'),
          //           // ),
          //           // Padding(
          //           //   padding: const EdgeInsets.only(top: 10, bottom: 20),
          //           //   child: Text(
          //           //     "Sign In",
          //           //     style: TextStyle(
          //           //       fontSize: 32,
          //           //       fontWeight: FontWeight.w100,
          //           //       color: Colors.white,
          //           //     ),
          //           //   ),
          //           // ),
          //           // Padding(
          //           //   padding: const EdgeInsets.only(top: 10),
          //           //   child:
          //           //       Text("Enter the Screen Code to Launch the Signage Preview",
          //           //           style: TextStyle(
          //           //             fontSize: 17,
          //           //             fontWeight: FontWeight.bold,
          //           //           )),
          //           // ),
          //           // Padding(
          //           //   padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
          //           //   child: TextField(
          //           //     controller: screenCodeController,
          //           //     decoration: InputDecoration(
          //           //       labelText: "Screen Code",
          //           //       errorText: screenCodeError,
          //           //     ),
          //           //   ),
          //           // ),
          //           BlocConsumer<RegisterblocBloc, RegisterblocState>(
          //             listener: (context, state) {
          //             },
          //             builder: (context, state) {
          //               return Padding(
          //                 padding: const EdgeInsets.only(
          //                     top: 0, left: 50, right: 50),
          //                 child: Container(
          //                   width: width / 2.5,
          //                   child: TextField(
          //                     style: TextStyle(
          //                         color: Color.fromARGB(255, 58, 85, 206)),
          //                     controller: screenCodeController,
          //                     decoration: InputDecoration(
          //                       labelText: 'Screen Code',
          //                       errorText: state.screenCodeErr,
          //                       labelStyle: TextStyle(
          //                           color: Color.fromARGB(255, 131, 154, 255)),
          //                       enabledBorder: UnderlineInputBorder(
          //                         borderSide: BorderSide(
          //                             color: Color.fromARGB(255, 131, 154, 255)),
          //                       ),
          //                       focusedBorder: UnderlineInputBorder(
          //                         borderSide: BorderSide(
          //                             color: Color.fromARGB(255, 131, 154, 255)),
          //                       ),
          //                       focusColor: Color.fromARGB(255, 131, 154, 255),
          //                       errorBorder: UnderlineInputBorder(),
          //                       errorStyle: TextStyle(
          //                         color: Color.fromARGB(255, 58, 85, 206)
          //                       )
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //           // Padding(
          //           //   padding: const EdgeInsets.only(top: 40),
          //           //   child: ElevatedButton(
          //           //       onPressed: () {
          //           //         validateInput();
          //           //       },
          //           //       style: ElevatedButton.styleFrom(
          //           //           backgroundColor: Colors.black,
          //           //           shape: RoundedRectangleBorder(
          //           //             borderRadius: BorderRadius.circular(8.0),
          //           //           ),
          //           //           padding:
          //           //               EdgeInsets.symmetric(horizontal: 70, vertical: 15)),
          //           //       child: Text(
          //           //         "Submit",
          //           //         style: TextStyle(color: Colors.white),
          //           //       )),
          //           // ),
          //           Padding(
          //             padding: const EdgeInsets.only(top: 70),
          //             child: InkWell(
          //               child: Container(
          //                 height: 35,
          //                 width: 150,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(50),
          //                   gradient: LinearGradient(
          //                     tileMode: TileMode.mirror,
          //                     colors: [
          //                       Color.fromARGB(255, 190, 218, 255),
          //                       Color.fromARGB(255, 99, 128, 255)
          //                     ],
          //                     begin: Alignment.bottomLeft,
          //                     end: Alignment.topRight,
          //                   ),
          //                 ),
          //                 child: Center(
          //                     child: Text(
          //                   "Submit",
          //                   style: TextStyle(color: Colors.white),
          //                 )),
          //               ),
          //               onTap: () {
          //                 // checkConnectivity();
          //                 validateInput(screenCodeController.text, context1);
          //               },
          //             ),
          //           ),
          //           // Padding(
          //           //   padding: const EdgeInsets.only(top: 10),
          //           //   child: InkWell(
          //           //     hoverColor: const Color.fromARGB(255, 224, 224, 224),
          //           //     onTap: () {
          //           //       registerClicked();
          //           //     },
          //           //     child: Text("Register",
          //           //         style: TextStyle(
          //           //           fontSize: 13,
          //           //           fontWeight: FontWeight.bold,
          //           //         )),
          //           //   ),
          //           // ),
          //           Padding(
          //             padding: const EdgeInsets.only(top: 10),
          //             child: InkWell(
          //               hoverColor: const Color.fromARGB(255, 224, 224, 224),
          //               onTap: () {
          //                 registerClicked();
          //               },
          //               child: Text("Register",
          //                   style: TextStyle(
          //                     color: Color.fromARGB(255, 131, 154, 255),
          //                     fontSize: 13,
          //                     fontWeight: FontWeight.normal,
          //                   )),
          //             ),
          //           ),
          //           BlocConsumer<RegisterblocBloc, RegisterblocState>(
          //             // buildWhen: (previous, current) {
          //             // },
          //             listener: (context, state) {
          //               if (state is LaunchScreen) {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => LaunchingScreen(
          //                             screenCode: state.code,
          //                           )),
          //                 );
          //               }
          //               if (state is DisplayRegistration) {
          //                 Navigator.of(context).push(createRoute());
          //                 // Navigator.push(
          //                 //   context,
          //                 //   MaterialPageRoute(
          //                 //       builder: (context) => RegisterScreen()),
          //                 // );
          //               }
          //               if (state is loginFailureState) {
          //                 print("failure state emittingggg");
          //                 showToast(context, state.message);
          //               }
          //             },
          //             builder: (context, state) {
          //               // if (state is LaunchScreen) {
          //               //   return Center();
          //               // }
          //               return Center();
          //             },
          //           ),
          //         ],
          //       ),
          //   ],
          // ),
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      foregroundColor: Color.fromARGB(255, 131, 154, 255),
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

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Center(
            child: LinearProgressIndicator(),
          ),
        );
      },
    );
  }
}
//login: ptcui
