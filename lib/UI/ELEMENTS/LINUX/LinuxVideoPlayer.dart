import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class LinuxVideoPlayer extends StatefulWidget {
  String url;
  LinuxVideoPlayer({required this.url});

  @override
  State<LinuxVideoPlayer> createState() => _LinuxVideoPlayerState();
}

class _LinuxVideoPlayerState extends State<LinuxVideoPlayer> {
  late VideoPlayerController _controller;
  bool isloading = true;
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future load() async {
    var file = await DefaultCacheManager().getSingleFile(widget.url);

    _controller = VideoPlayerController.file(file);

    _controller.addListener(() {});
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    isloading = false;
    setState(() {});
  }
}
