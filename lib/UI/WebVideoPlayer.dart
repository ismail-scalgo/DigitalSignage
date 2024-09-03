// // import 'package:cached_video_player_plus/cached_video_player_plus.dart';
// import 'package:cached_video_player/cached_video_player.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class WebPlayer extends StatefulWidget {
//   const WebPlayer({super.key});

//   @override
//   State<WebPlayer> createState() => _WebPlayerState();
// }

// class _WebPlayerState extends State<WebPlayer> {
//    late CachedVideoPlayerPlus controller;

//    void initState() {
//     controller = CachedVideoPlayerController.network(
//         "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
//     controller.initialize().then((value) {
//       controller.play();
//       setState(() {});
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Placeholder();
//   }
// }
