// // import 'package:flutter/material.dart';
// // import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// // import 'package:video_player/video_player.dart';

// // // import 'package:video_player_media_kit/video_player_media_kit.dart';

// // class CustomVideoPlayer extends StatefulWidget {
// //   String url;
// //   CustomVideoPlayer({required this.url});
// //   @override
// //   State<CustomVideoPlayer> createState() => CustomVideoPlayerState();
// // }

// // class CustomVideoPlayerState extends State<CustomVideoPlayer> {
// //   bool isLoading = true;

// //   late VideoPlayerController controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadWeb();
// //     // loadDevice();
// //   }

// //   @override
// //   void dispose() {
// //     controller.dispose();

// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //         child: isLoading
// //             ? Container(
// //                 color: Colors.black,
// //                 child: Center(
// //                   child: Text(
// //                     "Loading ..",
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               )
// //             : VideoPlayer(controller));
// //   }

// //   void loadWeb() async {
// //     controller = VideoPlayerController.networkUrl(Uri.parse(widget.url),
// //         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

// //     await controller.initialize();
// //     await controller.setLooping(true);
// //     await controller.setVolume(0);
// //     await controller.play();

// //     setState(() {
// //       isLoading = false;
// //     });
// //   }

// //   void loadDevice() async {
// //     //  var file = await DefaultCacheManager().downloadFile(widget.url);
// //     //  int size = await file.file.length();
// //     //  print(file.file.dirname);
// //     var file = await DefaultCacheManager().getSingleFile(widget.url);
// //     controller = VideoPlayerController.file(file,
// //         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

// //     await controller.initialize();
// //     await controller.setVolume(0);
// //     await controller.play();

// //     setState(() {
// //       isLoading = false;
// //     });
// //   }
// // }

// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// // import 'package:media_kit/media_kit.dart';
// // import 'package:media_kit_video/media_kit_video.dart';
// // // import 'package:video_player_media_kit/video_player_media_kit.dart';

// // class VideoPlayer extends StatefulWidget {
// //   String url;
// //   VideoPlayer({required this.url});
// //   @override
// //   State<VideoPlayer> createState() => VideoPlayerState();
// // }

// // class VideoPlayerState extends State<VideoPlayer> {
// //   late final player = Player();
// //   late final controller = VideoController(
// //     player,
// //   );
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadWeb();
// //     // loadDevice();
// //   }

// //   @override
// //   void dispose() {
// //     player.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: isLoading
// //           ? Container(
// //               color: Colors.black,
// //               child: Center(
// //                 child: Text(
// //                   "Loading ..",
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //               ),
// //             )
// //           : SizedBox(
// //               child: Video(
// //                 fit: BoxFit.fill,
// //                 controller: controller,
// //                 controls: (state) {
// //                   player.setVolume(0);
// //                   controller.player.play();

// //                   return Center();
// //                 },
// //               ),
// //             ),
// //     );
// //   }

// //   void loadWeb() async {
// //     //  var file = await DefaultCacheManager().downloadFile(widget.url);
// //     //  int size = await file.file.length();
// //     //  print(file.file.dirname);
// //     // var file = await DefaultCacheManager().getSingleFile(widget.url,headers: {'Cache-Control': 'max-age=3600'});
// //     player.open(
// //       Media(
// //         widget.url,
// //       ),
// //       play: true,
// //     );
// //     controller.player.setPlaylistMode(PlaylistMode.loop);
// //     setState(() {
// //       isLoading = false;
// //     });
// //   }

// //   void loadDevice() async {
// //     var file = await DefaultCacheManager().getSingleFile(widget.url);
// //     player.open(
// //       Media(
// //         file.path,
// //       ),
// //       play: true,
// //     );
// //     controller.player.setPlaylistMode(PlaylistMode.loop);
// //     setState(() {
// //       isLoading = false;
// //     });
// //   }
// // }

// import 'package:digitalsignange/Costants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:video_player/video_player.dart';

// // import 'package:video_player_media_kit/video_player_media_kit.dart';

// class CustomVideoPlayer extends StatefulWidget {
//   String url;
//   CustomVideoPlayer({required this.url});
//   @override
//   State<CustomVideoPlayer> createState() => CustomVideoPlayerState();
// }

// class CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   bool isLoading = true;

//   late VideoPlayerController controller;

//   late final player = Player();
//   late final controllerweb = VideoController(
//     player,
//   );

//   @override
//   void initState() {
//     super.initState();
//     PLATFORM == "ANDROID" ? loadDevice() : loadWeb();
//   }

//   @override
//   void dispose() {
//     controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: isLoading
//             ? Container(
//                 color: Colors.black,
//                 child: Center(
//                   child: Text(
//                     "Loading ..",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               )
//             : getplayer());
//   }

//   Widget getplayer() {
//     return SizedBox(
//       child: Video(
//         fit: BoxFit.fill,
//         controller: controllerweb,
//         controls: (state) {
//           player.setVolume(0);
//           controllerweb.player.play();

//           return Center();
//         },
//       ),
//     );
//   }

//   void loadWeb() async {
//     player.open(
//       Media(
//         widget.url,
//       ),
//       play: true,
//     );
//     controllerweb.player.setPlaylistMode(PlaylistMode.loop);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   void loadDevice() async {
//     //  var file = await DefaultCacheManager().downloadFile(widget.url);
//     //  int size = await file.file.length();
//     //  print(file.file.dirname);
//     var file = await DefaultCacheManager().getSingleFile(widget.url);
//     controller = VideoPlayerController.file(file,
//         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

//     await controller.initialize();
//     await controller.setVolume(0);
//     await controller.play();

//     setState(() {
//       isLoading = false;
//     });
//   }
// }

import 'package:digitalsignange/Costants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
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

  late final player = Player();
  late final controllerweb = VideoController(
    player,
  );

  @override
  void initState() {
    super.initState();
    HARDCODEPLATFORM == "WEB" ? loadWeb() : loadDevice();
  }

  @override
  void dispose() {
    if (HARDCODEPLATFORM == "WEB") {
      controllerweb.player.dispose();
    } else {
      controller.dispose();
    }

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
    return HARDCODEPLATFORM == "WEB"
        ? SizedBox(
            child: Video(
              fit: BoxFit.fill,
              controller: controllerweb,
              controls: (state) {
                return Center();
              },
            ),
          )
        : VideoPlayer(controller);
  }

  void loadWeb() async {
    player.open(
      Media(
        widget.url,
      ),
      play: true,
    );
    // player.setVolume(1);
    controllerweb.player.play();
    controllerweb.player.setPlaylistMode(PlaylistMode.loop);
    setState(() {
      isLoading = false;
    });

    Future.delayed(Duration(seconds: 5), () {
      //controllerweb.player.setVolume(1);
      print("VOLUME INCREASED");
    });
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
  }
}
