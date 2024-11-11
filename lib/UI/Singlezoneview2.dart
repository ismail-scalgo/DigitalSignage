import 'package:better_player/better_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';
import 'package:digitalsignange/UI/FlutterNativevideoplayer.dart';
import 'package:digitalsignange/UI/FlutterVideoplayer.dart';


import 'package:digitalsignange/UI/ImageScreen.dart';
import 'package:digitalsignange/UI/MediakitWebPlayer.dart';
import 'package:digitalsignange/UI/MyMediaKitVideoPlayer.dart';
import 'package:digitalsignange/UI/MyVlcPlayer.dart';

import 'package:digitalsignange/UI/PdfView.dart';
import 'package:digitalsignange/UI/VideoPLayer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pdfx/pdfx.dart';

class SingleZoneView2 extends StatefulWidget {
  ZoneData zonedata;
  SingleZoneView2({required this.zonedata});

  @override
  State<SingleZoneView2> createState() => _SingleZoneView2State();
}

class _SingleZoneView2State extends State<SingleZoneView2> {


  double factor = 0;
  int currentIndex = 0;
  bool isfirst = true;

  bool isvisible = false;

  bool isdisposed = false;

  @override
  void initState() {
    print("intit state calleddddddddddddddddddddddddd");
 
    if (isfirst) {
 
      changeController();
      isfirst = false;

    }
    super.initState();
  }

  @override
  void dispose() {
    isdisposed = true;

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return getWidget(widget
                    .zonedata.compositionModels[currentIndex]);

  }

  Widget getWidget(CompositionModel compositiondata) {
    if (compositiondata.fileFormat == "jpeg" ||
        compositiondata.fileFormat == "jpg" ||
        compositiondata.fileFormat == "png") {
      String fullUrl = BASEURL + compositiondata.fileUrl;
      return Container(
        width: (gwidth * widget.zonedata.widthPercent) / 100,
        height: (gheight * widget.zonedata.heightPercent) / 100,
        child: ImageScreen(url: fullUrl),
      );
    } else if (compositiondata.fileFormat == "mp4") {
      String fullUrl = BASEURL + compositiondata.fileUrl;

      double aspectRatio=(gwidth * widget.zonedata.widthPercent)/(gheight * widget.zonedata.heightPercent);
    // return CustomVideoPlayer(url: fullUrl);
  // return MediaKitWebPlayer(url: fullUrl);
  return FlutterNativeVideoPlayer(url: fullUrl,);
 //return Mymediakitvideoplayer(url: fullUrl);
 // return FlutterVideoPlayer(url: fullUrl);
      // return VideoPlayer(url: fullUrl);
    // return MyVlcPlayer(aspectratio: aspectRatio, url: fullUrl);
    // return AndroidVideoPlayer(url: fullUrl);
    // return AspectRatio(
    //   aspectRatio: aspectRatio,
    //   child:AndroidVideoPlayer(url: fullUrl));
    } else if (compositiondata.fileFormat == "pdf") {
      String fullUrl = BASEURL + compositiondata.fileUrl;
      return CustomPdf(fullUrl);
    }
    return Center(
      child: Text("Unknown media format"),
    );
  }

  void changeController() async {
    if (widget.zonedata.compositionModels.length - 1 < currentIndex) {
      currentIndex = 0;
    }
   
    Future.delayed(
        Duration(
            seconds: double.parse(widget
                    .zonedata.compositionModels[currentIndex].fileDuration)
                .toInt()), () async {


if(!isdisposed)
{
          currentIndex++;
        changeController();
        setState(() {
          
        });
}
    });
  }
}
