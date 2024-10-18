// ignore_for_file: unused_import, unnecessary_import

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
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:toastification/toastification.dart';

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
    // checkConnectivity();
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
            saveScreenCode(state.screenCode);
            return Container(
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
                          "Pair device",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 190, 190, 190),
                              fontSize: 25,
                              // fontSize: width / 45,
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
                              // fontSize: width / 50,
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
                              // fontSize: width / 50,
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
                              // fontSize: width / 20,
                              fontWeight: FontWeight.bold),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 50),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       // QrImageView(
                        //       //   data: 'Flutter',
                        //       //   version: QrVersions.auto,
                        //       //   size: 320,
                        //       //   gapless: false,
                        //       //   embeddedImage: AssetImage('assets/QR.webp'),
                        //       //   embeddedImageStyle: QrEmbeddedImageStyle(
                        //       //     size: Size(250, 250),
                        //       //   ),
                        //       // ),
                        //       Container(
                        //         color: Colors.white,
                        //         height: height / 4,
                        //         width: height / 4,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(15.0),
                        //           child: PrettyQrView.data(
                        //             data: 'https://www.nike.com/',
                        //             // decoration: const PrettyQrDecoration(
                        //             //   image: PrettyQrDecorationImage(
                        //             //     image: AssetImage('assets/QR.webp'),
                        //             //   ),
                        //             // ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          // if (state is DisplayOldScreenCode) {
          //   return Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         tileMode: TileMode.mirror,
          //         colors: [
          //           Color.fromARGB(255, 86, 0, 224),
          //           Color.fromARGB(255, 0, 0, 0),
          //           Color.fromARGB(255, 0, 0, 0),
          //           Color.fromARGB(255, 0, 0, 0),
          //           Color.fromARGB(255, 0, 0, 0)
          //         ],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //       ),
          //     ),
          //     height: height,
          //     width: width,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           // color: Colors.white,
          //           height: height / 1.2,
          //           width: width / 1.2,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "Pair device",
          //                 style: TextStyle(
          //                     color: const Color.fromARGB(255, 190, 190, 190),
          //                     fontSize: 25,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //               SizedBox(
          //                 height: 40,
          //               ),
          //               Text(
          //                 "1,  Login to your Digital Signage account at www.web-sgdsg.com",
          //                 style: TextStyle(
          //                     color: const Color.fromARGB(255, 190, 190, 190),
          //                     fontSize: 20,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //               SizedBox(
          //                 height: 40,
          //               ),
          //               Text(
          //                 "2,  Select New Screen and enter this code in the popup",
          //                 style: TextStyle(
          //                     color: const Color.fromARGB(255, 190, 190, 190),
          //                     fontSize: 20,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //               SizedBox(
          //                 height: 50,
          //               ),
          //               Text(
          //                 state.screenCode,
          //                 style: TextStyle(
          //                     color: const Color.fromARGB(255, 190, 190, 190),
          //                     fontSize: 50,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }
          return Container(
            color: Colors.black,
            width: width,
            height: height,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      )),
    );
  }

  void checkScreenCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('NewScreenCode');
    // prefs.remove('isRegistered');
    // await prefs.setString('NewScreenCode', "RZ95T1");
    String? screenCode = prefs.getString('NewScreenCode');
    bool? isRegistered = prefs.getBool('isRegistered');
    if (isRegistered == null) {
      isRegistered = false;
    }
    print("code = $screenCode");
    print("register = $isRegistered");
    if (screenCode == null) {
      print("null code");
      checkConnectivity();
      requestScreenCode();
    } else if (screenCode != null && !isRegistered!) {
      checkConnectivity();
      registerBloc.add(DisplayScreenCode(screenCode: screenCode));
    } else if (screenCode != null && isRegistered!) {
      print("got it");
      registerBloc.add(LaunchSignage(screenCode: screenCode));
    }
  }

  void saveScreenCode(String screenCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('NewScreenCode', screenCode);
    await prefs.setBool('isRegistered', false);
  }

  void requestScreenCode() async {
    request = RequestModel(
        width: MediaQuery.of(context).size.width.toInt().toString(),
        height: MediaQuery.of(context).size.height.toInt().toString());
    print("adding event");
    registerBloc.add(GetScreenCode(request: request));
  }
  void checkConnectivity() async {
    if (await isOffline()) {
      showToast(context, "No Internet Connection");
    }
  }
  void showToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      foregroundColor: Color.fromARGB(255, 63, 0, 235),
      type: ToastificationType.success,
      style: ToastificationStyle.simple,
      title: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
}
