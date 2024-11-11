// import 'package:digitalsignange/UI/VIDEOLOCK.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:native_video_player/native_video_player.dart';

// class FlutterNativeVideoPlayer extends StatefulWidget {
//   final String url;

//   FlutterNativeVideoPlayer({required this.url});

//   @override
//   State<FlutterNativeVideoPlayer> createState() => _FlutterNativeVideoPlayerState();
// }

// class _FlutterNativeVideoPlayerState extends State<FlutterNativeVideoPlayer> {
//   NativeVideoPlayerController? _controller;
//   bool isFirstLoad = true;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: Stack(
//         children: [
//           NativeVideoPlayerView(
//             onViewReady: (controller) async {
//               _controller = controller;
//               print("INSIDE WIDGET");

//               // Preload the video as soon as the view is ready
//               await preloadVideo(_controller);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Method to preload the video
//   Future<void> preloadVideo(NativeVideoPlayerController? controller) async {
//     if (!ISVIDEOLOCKED) {
//       ISVIDEOLOCKED = true;

//       // Set the volume to 0 while preloading
//       await controller?.setVolume(0.0);
//       await _loadVideoSource();

//       // Play the video after loading
//       await controller?.play();

//       // Add listener for playback ended event only once
//       if (isFirstLoad) {
//         controller?.onPlaybackEnded.addListener(_onPlaybackEnded);
//         isFirstLoad = false;
//       }

//       ISVIDEOLOCKED = false;
//     } else {
//       // Retry after a delay if the video is locked
//       await Future.delayed(Duration(seconds: 1));
//       await preloadVideo(controller);
//     }
//   }

//   // Method to initialize and load video source
//   Future<void> _loadVideoSource() async {
//     final videoSource = await VideoSource.init(
//       type: VideoSourceType.network,
//       path: widget.url,
//     );
//     await _controller?.loadVideoSource(videoSource);
//   }

//   // Callback when playback ends
//   void _onPlaybackEnded() {
//     print("PLAYBACK ENDED");
//     _controller?.play(); // Restart the video after it ends
//   }

//   // Called when widget's properties change
//   @override
//   void didUpdateWidget(covariant FlutterNativeVideoPlayer oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (oldWidget.url != widget.url) {
//       print("URL HAS CHANGED, RELOADING VIDEO");
      
//       // If URL changes, stop the current video and reload it
//       _controller?.stop();
//       preloadVideo(_controller); // Preload the new video
//     }
//   }

//   // Cleanup resources when widget is disposed
//   @override
//   void dispose() {
//     print("DISPOSING OF RESOURCES");

//     // Stop playback and remove listener before disposing
//     _controller?.stop();
//     _controller?.removeListener(_onPlaybackEnded);

//     super.dispose();
//   }
// }





import 'package:digitalsignange/UI/VIDEOLOCK.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:native_video_player/native_video_player.dart';

class FlutterNativeVideoPlayer extends StatefulWidget {
  final String url;

  FlutterNativeVideoPlayer({required this.url});

  @override
  State<FlutterNativeVideoPlayer> createState() => _FlutterNativeVideoPlayerState();
}

class _FlutterNativeVideoPlayerState extends State<FlutterNativeVideoPlayer> {
  NativeVideoPlayerController? _controller;
 
    bool isAutoplayEnabled = true;
  bool isPlaybackLoopEnabled = true;


    @override
  void didUpdateWidget(FlutterNativeVideoPlayer oldWidget) {
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
      var file1 = await DefaultCacheManager().downloadFile(widget.url);
    return VideoSource.init(
      path: file1.file.path,
      type:VideoSourceType.file,

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

