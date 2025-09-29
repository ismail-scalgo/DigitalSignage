import 'package:player/CONTENTLOG.dart';
import 'package:player/Costants.dart';
import 'package:player/MODELS/XCompositionModel.dart';
import 'package:player/UI/APPS/HtmlApps.dart';
import 'package:player/UI/APPS/ScrollText.dart';
import 'package:player/UI/ELEMENTS/ANDROID/AndroidVideoPlayer.dart';
import 'package:player/UI/ELEMENTS/ANDROID/IframeYouTubePlayer.dart';
import 'package:player/UI/ELEMENTS/COMMON/ImageView.dart';
import 'package:player/UI/ELEMENTS/COMMON/PdfView.dart';
import 'package:flutter/material.dart';



class SingleZoneController extends StatefulWidget {
  ZoneData zonedata;
  String broadcast_id;

  SingleZoneController({required this.zonedata, required this.broadcast_id});
  @override
  State<SingleZoneController> createState() => _SingleZoneControllerState();
}

class _SingleZoneControllerState extends State<SingleZoneController> {
  double factor = 0;
  int currentIndex = 0;
  bool isfirst = true;

  bool isvisible = false;

  bool isdisposed = false;

  @override
  void initState() {
    if (isfirst) {
      changeController();
      isfirst = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    print("zone disposing");
    isdisposed = true;

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map content_start_data = {
      'event': "content_add_event",
      'broadcast_id': widget.broadcast_id,
      'content_name': widget.zonedata.compositionModels[currentIndex].filename,
      'content_duration':
          widget.zonedata.compositionModels[currentIndex].fileDuration,
      'content_zone': widget.zonedata.id
    };

    controller.add(content_start_data);

    return getWidget(widget.zonedata.compositionModels[currentIndex]);
  }

  Widget getWidget(CompositionModel compositiondata) {
    if (compositiondata.fileFormat == ".jpeg" ||
        compositiondata.fileFormat == ".jpg" ||
        compositiondata.fileFormat == ".png") {
      String fullUrl = BASEURLMEDIA + compositiondata.fileUrl;
      return Container(
        width: (gwidth * widget.zonedata.widthPercent) / 100,
        height: (gheight * widget.zonedata.heightPercent) / 100,
        child: ImageScreen(url: fullUrl),
      );
    } else if (compositiondata.fileFormat == ".mp4") {
      String fullUrl = BASEURLMEDIA + compositiondata.fileUrl;

      double aspectRatio = (gwidth * widget.zonedata.widthPercent) /
          (gheight * widget.zonedata.heightPercent);
      // return CustomVideoPlayer(url: fullUrl);
      // return MediaKitWebPlayer(url: fullUrl);
      print("url1 = ${fullUrl}");
      print("file path = ${compositiondata.localstoragepath}");
      return AndroidVideoPlayer(
        url: fullUrl,
        filepath: compositiondata.localstoragepath,
        hasVolume: widget.zonedata.isMuted,
        
        key: Key(fullUrl+widget.zonedata.isMuted.toString()),
      );

//        url2 = https://web-dev-sgdsignage.scalgo.net/media/uploads/4.%20Sooraj/ForBiggerEscapes_pHCKvHE.mp4
//        I/flutter (27480): FILE PATH OF VIDEOOOOOOOOOOO
//        I/flutter (27480): /data/user/0/com.example.digitalsignange/cache/libCachedImageData/e31063c0-a727-11ef-8641-cd3ad725e104.mp4
//        D/VRI[]   (27480): vri.reportDrawFinished
      // return Mymediakitvideoplayer(url: fullUrl);
      // return FlutterVideoPlayer(url: fullUrl);
      // return VideoPlayer(url: fullUrl);
      // return MyVlcPlayer(aspectratio: aspectRatio, url: fullUrl);
      // return AndroidVideoPlayer(url: fullUrl);
      // return AspectRatio(
      //   aspectRatio: aspectRatio,
      //   child:AndroidVideoPlayer(url: fullUrl));
    } else if (compositiondata.fileFormat == ".pdf") {
      String fullUrl = BASEURLMEDIA + compositiondata.fileUrl;
      return CustomPdf(
        url: fullUrl,
        key: Key(fullUrl),
      );
    } else if (compositiondata.fileFormat == ".html") {
      print("HTML APP CALLED  URL ${compositiondata.fileUrl}");

      if (compositiondata.appType == 'Youtube') {
        return Iframeyoutubeplayer(url: compositiondata.youtube_url);
      } else {
        return HtmlApps(
          htmlUrl: BASEURLMEDIA + compositiondata.fileUrl,
          key: Key(compositiondata.fileUrl),
        );
      }

      //  {
      //                       "content_id": 170,
      //                       "content_name": "ForBiggerMeltdowns",
      //                       "text_content": "HAII MY NAME",
      //                       "file_format": "scroll_text",
      //                       "font_color":0xFF4CAF50,
      //                       "background_color":0xFFFFC107,
      //                       "speed":12 ,
      //                       "direction" : ,
      //                   },

      // return HtmlApps(
      //   htmlUrl: BASEURLMEDIA + compositiondata.fileUrl,key:Key(compositiondata.fileUrl),
      // );
      // return Iframeyoutubeplayer(url: "https://www.youtube.com/watch?v=EJxeMbDTkVI");
    }
    return Center(
      child: Text("Unknown media format"),
    );
  }

  void changeController() async {
    if (widget.zonedata.compositionModels.length - 1 < currentIndex) {
      currentIndex = 0;
    }

    print(
        "durrrrrrrrrrrrrrrrr = ${widget.zonedata.compositionModels[currentIndex].fileDuration}");
    Future.delayed(
        Duration(
            seconds: double.parse(widget
                    .zonedata.compositionModels[currentIndex].fileDuration)
                .toInt()), () async {
      if (!isdisposed) {
        currentIndex++;
        changeController();
        setState(() {});
      }
    });
  }
}
