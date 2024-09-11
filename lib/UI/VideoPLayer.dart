import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

// import 'package:video_player_media_kit/video_player_media_kit.dart';

class CustomVideoPlayer extends StatefulWidget {
  String url;
  CustomVideoPlayer({required this.url});
  @override
  State<CustomVideoPlayer> createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends State<CustomVideoPlayer> {
  bool isLoading = true;

  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    // loadWeb();
    loadDevice();
  }

  @override
  void dispose() {
    controller.dispose();

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
            : VideoPlayer(controller));
  }

  void loadWeb() async {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    await controller.initialize();
    await controller.setLooping(true);
    await controller.setVolume(0);
    await controller.play();

    setState(() {
      isLoading = false;
    });
  }

  void loadDevice() async {
    //  var file = await DefaultCacheManager().downloadFile(widget.url);
    //  int size = await file.file.length();
    //  print(file.file.dirname);
    var file = await DefaultCacheManager().getSingleFile(widget.url);
    controller = VideoPlayerController.file(file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    await controller.initialize();
    await controller.setVolume(0);
    await controller.play();

    setState(() {
      isLoading = false;
    });
  }
}
