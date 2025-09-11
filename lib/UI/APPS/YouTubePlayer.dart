import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayer extends StatefulWidget {
  String videoUrl;

  YouTubePlayer({required this.videoUrl});

  @override
  State<YouTubePlayer> createState() => _YouTubePlayer1State();
}

class _YouTubePlayer1State extends State<YouTubePlayer> {
  late YoutubePlayerController _controller;
  bool isloading = true;

  @override
  void initState() {
    load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? CircularProgressIndicator()
        : YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
            onReady: () {
              //_controller.addListener(listener);
            },
            // ),
          );
  }

  void load() {
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          hideControls: true,
          hideThumbnail: true,
          enableCaption: false,
          loop: true),
    );

    isloading = false;
    setState(() {});
  }
}
