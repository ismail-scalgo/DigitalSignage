import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  String url;
  YouTubePlayerScreen({required this.url,super.key});

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

  

    _controller = YoutubePlayerController(
      initialVideoId: extractVideoId(widget.url),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        isLive: false,
        disableDragSeek: true,
        loop: true,
        hideControls: true,
      ),
    );
  }

  String extractVideoId(String url) {
    // Regular expression for matching YouTube URLs
    final RegExp regExp = RegExp(
      r'(?:https?://(?:www\.)?youtube\.com/watch\?v=|https?://youtu\.be/)([a-zA-Z0-9_-]+)',
    );

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
     
      onReady: () {
        debugPrint('Player is ready.');
      },
    );
  }
}
