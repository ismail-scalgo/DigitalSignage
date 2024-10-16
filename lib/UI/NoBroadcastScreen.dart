import 'package:digitalsignange/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:digitalsignange/UI/LoginScreen.dart';
import 'package:digitalsignange/UI/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stroke_text/stroke_text.dart';

class NoBroadCastScreen extends StatelessWidget {
  NoBroadCastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: width,
            height: height,
            // color: Color.fromARGB(255, 226, 59, 9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                colors: [
                  Color.fromARGB(255, 218, 53, 3),
                  Color.fromARGB(255, 218, 53, 3)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            // color: const Color.fromARGB(255, 201, 200, 192),
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: width / 2,
                        height: height / 2,
                        // color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientText("NO",
                                style: GoogleFonts.protestStrike(
                                    textStyle: TextStyle(
                                        color: Color.fromARGB(255, 65, 51, 51),
                                        fontSize: width > height
                                            ? width / 12
                                            : height / 12,
                                        fontWeight: FontWeight.w500),
                                    height: 0.8),
                                colors: [
                                  Color.fromARGB(255, 65, 51, 51),
                                  Color.fromARGB(255, 65, 51, 51),
                                  Color.fromARGB(255, 65, 51, 51),
                                  Color.fromARGB(255, 65, 51, 51)
                                ]
                                // style: TextStyle(
                                //     color: Color.fromARGB(255, 65, 51, 51),
                                //     fontSize: 100,
                                //     fontWeight: FontWeight.bold),
                                ),
                            Text(
                              "BROADCAST",
                              style: GoogleFonts.protestStrike(
                                textStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: width > height
                                        ? width / 17
                                        : height / 17,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0),
                              ),
                              // glowColor: Colors.white,
                              // blurRadius: 8,
                              // gradientType: GradientType.linear,
                              // radius: 10,
                              // style: TextStyle(
                              //     color: Color.fromARGB(255, 255, 255, 255),
                              //     fontSize: 50,
                              //     fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Center(
                    //   child: GradientText("NO",
                    //       style: GoogleFonts.protestStrike(
                    //           textStyle: TextStyle(
                    //               color: Color.fromARGB(255, 65, 51, 51),
                    //               fontSize: 150,
                    //               fontWeight: FontWeight.w500)),
                    //       colors: [
                    //         Color.fromARGB(255, 65, 51, 51),
                    //         Color.fromARGB(255, 65, 51, 51),
                    //         Color.fromARGB(255, 65, 51, 51),
                    //         Color.fromARGB(255, 65, 51, 51)
                    //       ]
                    //       // style: TextStyle(
                    //       //     color: Color.fromARGB(255, 65, 51, 51),
                    //       //     fontSize: 100,
                    //       //     fontWeight: FontWeight.bold),
                    //       ),
                    // ),
                    // GradientText(
                    //   "BROADCAST",
                    //   style: GoogleFonts.protestStrike(
                    //     textStyle: TextStyle(
                    //         color: Color.fromARGB(255, 255, 255, 255),
                    //         fontSize: 70,
                    //         fontWeight: FontWeight.bold,
                    //         letterSpacing: 0),
                    //   ),
                    //   gradientType: GradientType.linear,
                    //   // radius: 10,
                    //   colors: [
                    //     Color.fromARGB(255, 255, 255, 255),
                    //     Colors.white,
                    //     Colors.white,
                    //     Colors.white,
                    //     Colors.white,
                    //     Color.fromARGB(255, 255, 255, 255)
                    //   ],
                    //   // style: TextStyle(
                    //   //     color: Color.fromARGB(255, 255, 255, 255),
                    //   //     fontSize: 50,
                    //   //     fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
              ],
            ),
            // child: Text("No\nBroadcast",
            // style: TextStyle(
            //   color: Colors.black,
            //   fontSize: 20,
            //   fontWeight: FontWeight.bold
            // ),
            // )
          ),
        ),
      ),
    );
  }
}
