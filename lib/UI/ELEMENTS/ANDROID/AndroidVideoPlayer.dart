import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:native_video_player/native_video_player.dart';

class AndroidVideoPlayer extends StatefulWidget {
  final String url;
  final String filepath;

  AndroidVideoPlayer({required this.url, required this.filepath});

  @override
  State<AndroidVideoPlayer> createState() => _AndroidVideoPlayerState();
}

class _AndroidVideoPlayerState extends State<AndroidVideoPlayer> {
  NativeVideoPlayerController? _controller;

  bool isAutoplayEnabled = true;
  bool isPlaybackLoopEnabled = true;

  @override
  void didUpdateWidget(AndroidVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadVideoSource();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NativeVideoPlayerView(
          onViewReady: _initController,
        ),
      ],
    );
  }

  Future<void> _initController(NativeVideoPlayerController controller) async {
    _controller = controller;

    _controller?. //
        onPlaybackReady
        .addListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .addListener(_onPlaybackEnded);

    await _loadVideoSource();
  }

  @override
  void dispose() {
    _controller?. //
        onPlaybackReady
        .removeListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .removeListener(_onPlaybackEnded);
    _controller = null;
    super.dispose();
  }

  Future<void> _loadVideoSource() async {
    final videoSource = await _createVideoSource();
    await _controller?.loadVideoSource(videoSource);
  }

  Future<VideoSource> _createVideoSource() async {
    print("FILE PATH OF VIDEOOOOOOOOOOO");
    print(widget.filepath);

    // var file1 = await DefaultCacheManager().downloadFile(widget.url);
    return VideoSource.init(
      path: widget.filepath,
      type: VideoSourceType.file,
    );
  }

  void _onPlaybackReady() {
    setState(() {});
    if (isAutoplayEnabled) {
      _controller?.play();
    }
  }

  void _onPlaybackEnded() {
    if (isPlaybackLoopEnabled) {
      _controller?.play();
    }
  }
}
