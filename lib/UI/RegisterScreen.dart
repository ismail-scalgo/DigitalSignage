// // ignore_for_file: prefer_const_constructors, unused_import

// import 'package:digitalsignange/UI/LoginScreen.dart';
// import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
// import 'package:digitalsignange/MODELS/RequestModel.dart';
// import 'package:digitalsignange/UI/newUi.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:io' show Platform;
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class RegisterScreen extends StatefulWidget {
//   RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final screenNameController = TextEditingController();
//   final agentIdController = TextEditingController();
//   late RegisterblocBloc registerBloc;
//   String? screenError;
//   String? agentError;
//   late String platform;
//   late RequestModel request;

//   static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   Map<String, dynamic> deviceData = <String, dynamic>{};
//   Position? currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     registerBloc = BlocProvider.of<RegisterblocBloc>(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     // print(Platform.isAndroid);
//     // print("height = $height");
//     // print("width = $width");
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 255, 255, 255),
//       body: SafeArea(
//           child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             tileMode: TileMode.mirror,
//             colors: [
//               Color.fromARGB(255, 255, 163, 163),
//               Color.fromARGB(255, 28, 91, 128)
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         height: height,
//         width: width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: height / 1.2,
//               width: width / 1.7,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   // BoxShadow(
//                   //   color: Colors.grey
//                   //       .withOpacity(0.5), // Shadow color with opacity
//                   //   spreadRadius: 5, // Spread radius
//                   //   blurRadius: 7, // Blur radius
//                   //   offset: Offset(0, 3), // Offset in the X and Y direction
//                   // ),
//                 ],
//                 gradient: LinearGradient(
//                   tileMode: TileMode.mirror,
//                   colors: [
//                     Color.fromARGB(255, 255, 197, 197),
//                     Color.fromARGB(255, 49, 51, 82)
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 color: Color.fromARGB(255, 224, 224, 224),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "SignUp",
//                     style: TextStyle(

//                         fontSize: 25,
//                         fontWeight: FontWeight.w100,
//                         color: Colors.white,
//                         ),

//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 10),
//                   //   child: Text("Enter details to register your screen",
//                   //       style: TextStyle(
//                   //         fontSize: 20,
//                   //         fontWeight: FontWeight.normal,
//                   //         color: Colors.white
//                   //       )),
//                   // ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(top: 30, left: 50, right: 50),
//                     child: TextField(
//                       style:
//                           TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
//                       controller: screenNameController,
//                       decoration: InputDecoration(
//                         labelText: 'Screen Name',

//                         errorText: screenError,
//                         labelStyle: TextStyle(color:  Color.fromARGB(255, 221, 220, 220)),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Color.fromARGB(255, 221, 220, 220)),
//                         ),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Color.fromARGB(255, 221, 220, 220)),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(top: 10, left: 50, right: 50),
//                     child: TextField(
//                       controller: agentIdController,
//                       decoration: InputDecoration(
//                         labelText: "Agent Id",
//                         errorText: agentError,
//                         labelStyle: TextStyle(color:  Color.fromARGB(255, 221, 220, 220)),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Color.fromARGB(255, 221, 220, 220)),
//                         ),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Color.fromARGB(255, 221, 220, 220)),
//                         ),
//                         // labelStyle: TextStyle(color: Colors.blue)
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 40),
//                     child: ElevatedButton(
//                         onPressed: () async {
//                           var location = await _determinePosition();
//                           var currentPlatform = await initPlatformState();
//                           var address = await fetchResponse(
//                               location.latitude, location.longitude);
//                           request = RequestModel(
//                               agentId: agentIdController.text,
//                               name: screenNameController.text,
//                               platform: currentPlatform,
//                               location: address,
//                               latitude: location.latitude,
//                               longitude: location.longitude,
//                               width: width,
//                               height: height);
//                           validateInput(request);
//                           // print("latitude = ${location.latitude}");
//                           // print("longitude = ${location.longitude}");

//                           // request.latitude = location.latitude;
//                           // request.longitude = location.longitude;
//                           // validateInput();
//                           // var address = await getPlacemarks(location.latitude, location.longitude);
//                           // print("address = $address");
//                           // _determinePosition();
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 70, vertical: 15)),
//                         child: Text(
//                           "Register",
//                           style: TextStyle(color: Colors.white),
//                         )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: InkWell(
//                       hoverColor: const Color.fromARGB(255, 224, 224, 224),
//                       onTap: () {
//                         launchSignageClicked();
//                       },
//                       child: Text("Launch Signage",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold,
//                           )),
//                     ),
//                   ),
//                   BlocConsumer<RegisterblocBloc, RegisterblocState>(
//                     // buildWhen: (previous, current) {
//                     // },
//                     listener: (context, state) {
//                       if (state is SignInScreen) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => NewUi()),
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       // if (state is LaunchScreen) {
//                       //   return Center();
//                       // }
//                       return Center();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }

//   Future<String> fetchResponse(double lat, double long) async {
//     var response = await http.get(Uri.parse(
//         'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json&addressdetails=1'));
//     // print("data= ${response.body}");
//     var data = json.decode(response.body);
//     var address = data["display_name"];
//     // print("response = $address");
//     // request.location = address;
//     return address;
//   }

//   // late Data responseData;
//   // var response = await http.get(Uri.parse(
//   //     'http://192.168.0.92:8000/api/launch-signage-screen/?code=FQVNJ'));
//   // // print("response data = ${response.body}");
//   // print("response data = ${response.statusCode}");
//   // if (response.statusCode == 200) {
//   //   final jsonData = json.decode(response.body);

//   //   responseData = Data.fromJson(jsonData["data"]);
//   //   print("response data = ${responseData}");
//   //   return responseData;
//   // } else {
//   //   print("Error");
//   // }
//   // https://nominatim.openstreetmap.org/reverse?lat=8.5610811&lon=76.8770507&format=json&addressdetails=1
//   // https://api.geoapify.com/v1/geocode/reverse?lat=8.5610875&lon=76.8770139&format=json&apiKey=d548c5ed24604be6a9dd0d989631f783

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   void validateInput(RequestModel requestData) {
//     setState(() {
//       if (agentIdController.text.trim().isEmpty) {
//         agentError = "AgentId is required";
//       } else {
//         agentError = null;
//       }
//       if (screenNameController.text.trim().isEmpty) {
//         screenError = "Screen Name is required";
//       } else {
//         screenError = null;
//       }
//     });
//     if ((screenNameController.text.trim().isNotEmpty) &&
//         (agentIdController.text.trim().isNotEmpty)) {
//       // request.agentId = agentIdController.text;
//       // request.name = screenNameController.text;
//       // request.height = MediaQuery.of(context).size.height;
//       // request.width = MediaQuery.of(context).size.width;
//       registerBloc.add(RegisterUser(request: request));
//     }

//     // if (Platform.isAndroid) {
//     //   platform = 'Android';
//     // } else if (Platform.isIOS) {
//     //   platform = 'iOS';
//     // } else if (Platform.isWindows) {
//     //   platform = 'Windows';
//     // } else if (Platform.isLinux) {
//     //   platform = 'Linux';
//     // } else if (Platform.isMacOS) {
//     //   platform = 'macOS';
//     // } else {
//     //   platform = 'Unknown';
//     // }
//     // print("platform = $platform");
//   }

//   Future<String> initPlatformState() async {
//     var deviceData = <String, dynamic>{};

//     try {
//       if (kIsWeb) {
//         deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
//         // print(deviceData);
//         // print("platform = ${deviceData['platform']}");
//         // platform = deviceData['platform'];
//         // request.platform = platform;
//         return deviceData['platform'];
//       } else {
//         if (Platform.isAndroid) {
//           platform = 'Android';
//         } else if (Platform.isIOS) {
//           platform = 'iOS';
//         } else if (Platform.isWindows) {
//           platform = 'Windows';
//         } else if (Platform.isLinux) {
//           platform = 'Linux';
//         } else if (Platform.isMacOS) {
//           platform = 'macOS';
//         } else {
//           platform = 'Unknown';
//         }
//         // print("platform = $platform");
//         // request.platform = platform;
//         return platform;
//       }
//     } on PlatformException {
//       deviceData = <String, dynamic>{
//         'Error:': 'Failed to get platform version.'
//       };
//     }
//     if (!mounted) return "";
//     setState(() {
//       deviceData = deviceData;
//       // print("platform = ${deviceData}");
//     });
//     return platform;
//   }

//   Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
//     return <String, dynamic>{
//       'browserName': data.browserName.name,
//       'appCodeName': data.appCodeName,
//       'appName': data.appName,
//       'appVersion': data.appVersion,
//       'deviceMemory': data.deviceMemory,
//       'language': data.language,
//       'languages': data.languages,
//       'platform': data.platform,
//       'product': data.product,
//       'productSub': data.productSub,
//       'userAgent': data.userAgent,
//       'vendor': data.vendor,
//       'vendorSub': data.vendorSub,
//       'hardwareConcurrency': data.hardwareConcurrency,
//       'maxTouchPoints': data.maxTouchPoints,
//     };
//   }

// //   Future<String> getPlacemarks(double lat, double long) async {
// //   try {
// //     List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
// //     print("Placemarks: $placemarks");

// //     if (placemarks.isNotEmpty) {
// //       Placemark place = placemarks[0];

// //       // Safely concatenate address components by checking for null values
// //       String address = '';

// //       if (place.street != null && place.street!.isNotEmpty) {
// //         address += place.street!;
// //       }
// //       if (place.subLocality != null && place.subLocality!.isNotEmpty) {
// //         address += ', ${place.subLocality}';
// //       }
// //       if (place.locality != null && place.locality!.isNotEmpty) {
// //         address += ', ${place.locality}';
// //       }
// //       if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
// //         address += ', ${place.subAdministrativeArea}';
// //       }
// //       if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
// //         address += ', ${place.administrativeArea}';
// //       }
// //       if (place.postalCode != null && place.postalCode!.isNotEmpty) {
// //         address += ', ${place.postalCode}';
// //       }
// //       if (place.country != null && place.country!.isNotEmpty) {
// //         address += ', ${place.country}';
// //       }

// //       address = address.trim();
// //       print("Your Address for ($lat, $long) is: $address");

// //       return address.isNotEmpty ? address : "No Address Found";
// //     } else {
// //       return "No Address Found";
// //     }
// //   } catch (e) {
// //     print("Error getting placemarks: $e");
// //     return "No Address";
// //   }
// // }

//   void launchSignageClicked() {
//     registerBloc.add(ShowSignIn());
//   }
// }

// ignore_for_file: prefer_const_constructors, unused_import, use_build_context_synchronously, prefer_const_literals_to_create_immutables

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
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     tileMode: TileMode.mirror,
          //     colors: [
          //       Color.fromARGB(255, 223, 124, 124),
          //       Color.fromARGB(255, 28, 91, 128)
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  height: height / 2,
                  width: width / 1,
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     tileMode: TileMode.mirror,
                  //     colors: [
                  //       Color.fromARGB(255, 212, 135, 135),
                  //       Color.fromARGB(255, 0, 69, 109)
                  //     ],
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //   ),
                  //   color: Color.fromARGB(255, 224, 224, 224),
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                  child: Lottie.asset('assets/Buildings.json'),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10, bottom: 20),
                  //   child: Text(
                  //     "Sign Up",
                  //     style: TextStyle(
                  //       fontSize: 32,
                  //       fontWeight: FontWeight.w100,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
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
                                  top: 0, left: 50, right: 50),
                              child: TextField(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 58, 85, 206)),
                                controller: screenNameController,
                                decoration: InputDecoration(
                                    labelText: 'Screen name',
                                    errorText: state.nameErr,
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 131, 154, 255)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 131, 154, 255)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 131, 154, 255)),
                                    ),
                                    focusColor:
                                        Color.fromARGB(255, 131, 154, 255),
                                    // errorBorder: UnderlineInputBorder(),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 58, 85, 206))),
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
                                    color: Color.fromARGB(255, 58, 85, 206)),
                                controller: agentIdController,
                                decoration: InputDecoration(
                                    labelText: 'Agent Id',
                                    errorText: state.agentIdErr,
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 131, 154, 255)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 131, 154, 255)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 131, 154, 255)),
                                    ),
                                    focusColor:
                                        Color.fromARGB(255, 131, 154, 255),
                                    errorBorder: UnderlineInputBorder(),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 58, 85, 206))),
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
                              Color.fromARGB(255, 190, 218, 255),
                              Color.fromARGB(255, 99, 128, 255)
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
                            color: Color.fromARGB(255, 131, 154, 255),
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
}
