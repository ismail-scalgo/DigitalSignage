import 'package:flutter/material.dart';
import 'package:player/Utils.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Iframeyoutubeplayer extends StatefulWidget {
  String url;

  Iframeyoutubeplayer({super.key, required this.url});

  @override
  State<Iframeyoutubeplayer> createState() => _IframeyoutubeplayerState();
}

class _IframeyoutubeplayerState extends State<Iframeyoutubeplayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    DebugPrint("URL ID IS " + widget.url);
    // _controller = YoutubePlayerController.fromVideoId(
    //   videoId: YoutubePlayerController.convertUrlToId(widget.url)!,
    //   // videoId: "sWMPlQ3-97c",
    //   autoPlay: true,
    //   params: const YoutubePlayerParams(
    //       showFullscreenButton: false,
    //       showControls: false,
    //       strictRelatedVideos: true,
    //       enableCaption: false),
    // );

    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: false,
        showControls: false,
        strictRelatedVideos: true,
        showVideoAnnotations: false,
        loop: true,
        enableCaption: false,
        showFullscreenButton: true,
      ),
    );

    String formattedYouTubeUrl =
        'http://www.youtube.com/v/${extractVideoId(widget.url)}';

    _controller.loadVideoByUrl(mediaContentUrl: formattedYouTubeUrl);

    _controller.enterFullScreen(lock: true);
    _controller.setVolume(100);
    _controller.setLoop(loopPlaylists: true);
    _controller.exitFullScreen(lock: true);

    // TODO: implement initState
    super.initState();
  }

  String extractVideoId(String url) {
    // Regular expression for matching YouTube URLs
    final RegExp regExp = RegExp(
        r'(?:https?://(?:www\.)?youtube\.com/watch\?v=|https?://youtu\.be/)([a-zA-Z0-9_-]+)');

    // Search for the video ID
    final match = regExp.firstMatch(url);

    // If a match is found, return the video ID, otherwise return an empty string
    if (match != null) {
      return match.group(1)!;
    } else {
      return ''; // Return empty string if no match
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
        ),
      ),
    );
  }
}
