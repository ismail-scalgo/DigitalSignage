import 'package:digitalsignange/Costants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart';

// import 'package:video_player_media_kit/video_player_media_kit.dart';

class AndroidVideoPlayer extends StatefulWidget {
  String url;
  AndroidVideoPlayer({required this.url});
  @override
  State<AndroidVideoPlayer> createState() => AndroidVideoPlayerState();
}

class AndroidVideoPlayerState extends State<AndroidVideoPlayer> {
  bool isLoading = true;

  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    loadDevice();
  }

  @override
  void dispose() async {
    await controller.dispose();

    TOTALPLAYERNO = TOTALPLAYERNO - 1;

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
    return VideoPlayer(controller);
  }

  void loadDevice() async {
    //  var file = await DefaultCacheManager().downloadFile(widget.url);
    //  int size = await file.file.length();
    //  print(file.file.dirname);
    var file = await DefaultCacheManager().getSingleFile(widget.url);
    controller = VideoPlayerController.file(file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    controller.initialize();
    controller.setVolume(0);
    controller.setLooping(true);
    controller.play();

    setState(() {
      isLoading = false;
    });

    TOTALPLAYERNO = TOTALPLAYERNO + 1;

    print("PLAYER TOTAL NO=" + TOTALPLAYERNO.toString());
  }
}
