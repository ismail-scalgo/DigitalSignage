import 'package:lottie/lottie.dart';
import 'package:player/CONTENTLOG.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class NoBroadcastWithoutInternetScreen extends StatefulWidget {
  NoBroadcastWithoutInternetScreen({super.key});

  @override
  State<NoBroadcastWithoutInternetScreen> createState() => _NoBroadcastWithoutInternetScreenState();
}

class _NoBroadcastWithoutInternetScreenState extends State<NoBroadcastWithoutInternetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    controller.add({'event':"broadcast_end_event"});

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "NO",
                style: GoogleFonts.protestStrike(
                    textStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: width / 12,
                        fontWeight: FontWeight.bold),
                    height: 0.8),
              ),
              SizedBox(
                width: width / 110,
              ),
              Text(
                "BROADCAST.",
                style: GoogleFonts.protestStrike(
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: width / 17,
                      letterSpacing: 0),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget noBroadCast(double height, double width) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NO",
                      style: GoogleFonts.protestStrike(
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: width / 12,
                              fontWeight: FontWeight.bold),
                          height: 0.8),
                    ),
                    SizedBox(
                      width: width / 110,
                    ),
                    Text(
                      "BROADCAST.",
                      style: GoogleFonts.protestStrike(
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: width / 17,
                            letterSpacing: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
