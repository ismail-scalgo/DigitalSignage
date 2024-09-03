import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
// import 'package:video_player_media_kit/video_player_media_kit.dart';

class VideoPlayer extends StatefulWidget {
  String url;
  VideoPlayer({required this.url});
  @override
  State<VideoPlayer> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(
    player,
  );
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // loadWeb();
    loadDevice();
  }

  @override
  void dispose() {
    player.dispose();
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
          : SizedBox(
              child: Video(
                fit: BoxFit.fill,
                controller: controller,
                controls: (state) {
                  player.setVolume(0);
                  controller.player.play();

                  return Center();
                },
              ),
            ),
    );
  }

  void loadWeb() async {
    //  var file = await DefaultCacheManager().downloadFile(widget.url);
    //  int size = await file.file.length();
    //  print(file.file.dirname);
    // var file = await DefaultCacheManager().getSingleFile(widget.url,headers: {'Cache-Control': 'max-age=3600'});
    player.open(
      Media(
        widget.url,
      ),
      play: true,
    );
    controller.player.setPlaylistMode(PlaylistMode.loop);
    setState(() {
      isLoading = false;
    });
  }

  void loadDevice() async {
    //  var file = await DefaultCacheManager().downloadFile(widget.url);
    //  int size = await file.file.length();
    //  print(file.file.dirname);
    var file = await DefaultCacheManager().getSingleFile(widget.url);
    player.open(
      Media(
        file.path,
      ),
      play: true,
    );
    controller.player.setPlaylistMode(PlaylistMode.loop);
    setState(() {
      isLoading = false;
    });
  }
}
