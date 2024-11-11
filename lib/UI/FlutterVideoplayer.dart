import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/UI/VIDEOLOCK.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:video_player/video_player.dart';
import 'dart:developer';

// import 'package:video_player_media_kit/video_player_media_kit.dart';

class FlutterVideoPlayer extends StatefulWidget {
  String url;
  FlutterVideoPlayer({required this.url});
  @override
  State<FlutterVideoPlayer> createState() => FlutterVideoPlayerState();
}

class FlutterVideoPlayerState extends State<FlutterVideoPlayer> {
  bool isLoading = true;

  late VideoPlayerController? controller;



  @override
  void initState() {
    super.initState();
    preloadvideo();
  }

  @override
  void dispose() async{

    await controller!.pause();
  
    await  controller!.dispose();

    controller=null;
    
 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: isLoading
            ? Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    "Loading ..",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : getplayer());
  }

  Widget getplayer() {
    return VideoPlayer(controller!);
  }


  void loadDevice() async {
    //  var file = await DefaultCacheManager().downloadFile(widget.url);
    //  int size = await file.file.length();
    //  print(file.file.dirname);
    ISVIDEOLOCKED=true;
    var file = await DefaultCacheManager().getSingleFile(widget.url);
    controller = VideoPlayerController.file(file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

   await controller!.initialize();


    controller!.setVolume(0);
    controller!.setLooping(true);
   await controller!.play();

    setState(() {
    
      isLoading = false;
      ISVIDEOLOCKED=false;
    });
  }

  void preloadvideo() async
  {
      if(!ISVIDEOLOCKED)
      {
        loadDevice();
      }
      else
      {
       await Future.delayed(Duration(seconds: 1));
     loadDevice();
      }


  }
}
