import 'package:better_player/better_player.dart';

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';
import 'package:digitalsignange/UI/AndroidVideoPlayer.dart';
import 'package:digitalsignange/UI/BetterVideoplayer.dart';
import 'package:digitalsignange/UI/ImageScreen.dart';
import 'package:digitalsignange/UI/LinuxVideoPlayer.dart';
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
    // widget.details.contentsList.forEach((element) {

    //   if(element.duration == "0.0") {
    //     widget.details.contentsList.remove(element);
    //   }
    // });
    // TODO: implement initState
    if (isfirst) {
      // widget.zonedata.compositionModels.forEach((element) {
      //   widgetList.add(getWidget(element));
      // });
      changeController();
      isfirst = false;
      // change();
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
    // return Container(
    //   color: Colors.red,
    // );
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
     return LinuxVideoPlayer(url: fullUrl);
      // return VideoPlayer(url: fullUrl);
    //  return MyVlcPlayer(aspectratio: aspectRatio, url: fullUrl);
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
    // print(
    // "content durationnnnnnnnnnnnnnnnnnnnnnnnnnnnnn  = ${widget.zonedata.compositionModels[currentIndex].fileDuration}");
    Future.delayed(
        Duration(
            seconds: double.parse(widget
                    .zonedata.compositionModels[currentIndex].fileDuration)
                .toInt()), () async {
      // if (!isdisposed) {
    
      //   isvisible = true;
      //   setState(() {});
      // }

      // Future.delayed(Duration(milliseconds: 400), () {
      //   if (!isdisposed) {
      //     isvisible = false;
      //     setState(() {});
      //   }
      // });
      // if (!isdisposed) {
      //   currentIndex++;
      //   changeController();
      // }

        currentIndex++;
        changeController();
        setState(() {
          
        });
    });
  }
}
