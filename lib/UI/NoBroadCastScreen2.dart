import 'package:digitalsignange/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:digitalsignange/UI/LoginScreen.dart';
import 'package:digitalsignange/UI/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:video_player/video_player.dart';

class NoBroadCastScreen extends StatefulWidget {
  NoBroadCastScreen({super.key});

  @override
  State<NoBroadCastScreen> createState() => _NoBroadCastScreenState();
}

class _NoBroadCastScreenState extends State<NoBroadCastScreen> {
  late VideoPlayerController controller;
  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    // var file = await DefaultCacheManager().getSingleFile(widget.url);
    super.initState();
    controller = VideoPlayerController.asset('assets/signageVideo1.mp4');
    controller.initialize();
    controller.setVolume(0);
    controller.setPlaybackSpeed(0.8);
    controller.setLooping(true);
    controller.play();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoad = true;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        color: Colors.black,
        child:
            isLoad ? noBroadCast(height, width) : LoadingWidget(height, width),
      ),
    );
  }

  Widget noBroadCast(double height, double width) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            child: VideoPlayer(controller),
            // child: Center(child: Text("No Broadcast"),),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 44, 43, 43).withOpacity(0.8)),
          ),
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
                                color: Color.fromARGB(255, 219, 210, 210),
                                fontSize: width / 12,
                                // fontSize: width > height
                                //     ? width / 12
                                //     : height / 12,
                                fontWeight: FontWeight.bold),
                            height: 0.8),
                      ),
                      SizedBox(width: width / 110,),
                      Text(
                        "BROADCAST.",
                        // holtwoodOneSc
                        // bonaNova
                        // bodoniModa
                        // protestStrike
                        style: GoogleFonts.protestStrike(
                          textStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 46, 15),
                              fontSize: width / 17,
                              // fontSize: width > height
                              //     ? width / 17
                              //     : height / 17,
                              // fontWeight: FontWeight.bold,
                              letterSpacing: 0),
                        ),
                      ),
                  ],
                ),
                // child: 
                // Container(
                //   width: width / 2,
                //   height: height / 2,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "NO",
                //         style: GoogleFonts.playfairDisplay(
                //             textStyle: TextStyle(
                //                 color: Color.fromARGB(255, 216, 213, 213),
                //                 fontSize: width / 12,
                //                 // fontSize: width > height
                //                 //     ? width / 12
                //                 //     : height / 12,
                //                 fontWeight: FontWeight.bold),
                //             height: 0.8),
                //       ),
                //       Text(
                //         "BROADCAST.",
                //         // holtwoodOneSc
                //         // bonaNova
                //         // bodoniModa
                //         // protestStrike
                //         style: GoogleFonts.notable(
                //           textStyle: TextStyle(
                //               color: Color.fromARGB(255, 218, 46, 15),
                //               fontSize: width / 17,
                //               // fontSize: width > height
                //               //     ? width / 17
                //               //     : height / 17,
                //               // fontWeight: FontWeight.bold,
                //               letterSpacing: 0),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget LoadingWidget(double height, double width) {
    return Center(
        child: Container(
            width: width / 10,
            height: width / 10,
            child: Lottie.asset('assets/loading3.json')));
  }
}
