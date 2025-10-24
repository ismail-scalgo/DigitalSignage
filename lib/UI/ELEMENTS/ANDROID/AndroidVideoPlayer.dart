import 'dart:io';

import 'package:player/UI/VIDEOLOCK.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:native_video_player/native_video_player.dart';

class AndroidVideoPlayer extends StatefulWidget {
  final String url; //JUST ONLY FOR PRINT URL
  final String filepath;
  final bool hasVolume;

  AndroidVideoPlayer(
      {required this.url,
      required this.filepath,
      required this.hasVolume,
      required super.key});

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
    // if (oldWidget.url != widget.url) {
    print("URL CHANGEDDDDDDDDDDDDDDD");
    checklockandchange();
    // }
  }

  Future checklockandchange() async {
    if (ISVIDEOLOCKED) {
      await Future.delayed(Duration(milliseconds: 500));
      checklockandchange();
    } else {
      ISVIDEOLOCKED = true;
      await changevideo();
      ISVIDEOLOCKED = false;
    }
  }

  Future changevideo() async {
    await _controller!.pause();

    await Future.delayed(Duration(seconds: 1));
    _loadVideoSource();
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
  void dispose() async{
        super.dispose();
        try{   
          await _controller?.stop();

        }catch(e){}

                try{   
          _controller?. //
        onPlaybackReady
        .removeListener(_onPlaybackReady);
    _controller?. //
        onPlaybackEnded
        .removeListener(_onPlaybackEnded);

        }catch(e){}

   
   

    _controller = null;


  }

  Future<void> _loadVideoSource() async {
    print("url2 = ${widget.url}");

    final videoSource = await _createVideoSource();

    await _controller?.loadVideoSource(videoSource);
  }

  Future<VideoSource> _createVideoSource() async {
    print("FILE PATH OF VIDEOOOOOOOOOOO");
    print(widget.filepath);

    // var file = await DefaultCacheManager().getSingleFile(widget.url);

    var file = File(widget.filepath);

    if (!(await file.exists())) {
      print("Androidvideplayer.dart");
      print("FILE PATH CORRUPTED");
      print("DOWNLOAD AGAIN");
      await DefaultCacheManager().removeFile(widget.url);
      file= (await DefaultCacheManager().getSingleFile(widget.url));
    }

    // var file1 = await DefaultCacheManager().downloadFile(widget.url);
    return VideoSource.init(
      path: file.path,
      type: VideoSourceType.file,
    );
  }

  void _onPlaybackReady() async {
    if (isAutoplayEnabled) {
      await _controller?.play();
      widget.hasVolume ? () : _controller?.setVolume(1);
    }
  }

  void _onPlaybackEnded() {
    if (isPlaybackLoopEnabled) {
      _controller?.play();
    }
  }
}
