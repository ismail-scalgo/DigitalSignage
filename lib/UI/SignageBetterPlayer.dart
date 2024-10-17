// import 'package:digitalsignange/UI/BetterPLayerCacheObject.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:better_player/better_player.dart';

// class SignageBetterPlayer extends StatefulWidget {
//   double aspctratio;
//   String url;
//   int zoneno;
//   SignageBetterPlayer(
//       {required this.aspctratio, required this.url, required this.zoneno});

//   @override
//   State<SignageBetterPlayer> createState() => _MybetterplayerState();
// }

// class _MybetterplayerState extends State<SignageBetterPlayer> {
//   late BetterPlayerController _betterPlayerController;

//   bool isloading = true;

//   @override
//   void initState() {
//     if (BETTERPLAYERCACHEOBJECTS[widget.zoneno] == null) {
//       BetterPlayerConfiguration betterPlayerConfiguration =
//           BetterPlayerConfiguration(
//         autoPlay: true,
//         looping: true,
//         handleLifecycle: false,
//         autoDispose: false,
//         autoDetectFullscreenAspectRatio: true,
//         aspectRatio: widget.aspctratio,
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//           showControls: false,
//         ),
//         // aspectRatio: widget.aspctratio,
//         fit: BoxFit.fill,
//       );
//       var controller = BetterPlayerController(betterPlayerConfiguration);
//       controller.setVolume(0);

//       BETTERPLAYERCACHEOBJECTS[widget.zoneno] = controller;
//     }

//     _betterPlayerController = BETTERPLAYERCACHEOBJECTS[widget.zoneno];

//     _setupDataSource();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BetterPlayer(controller: _betterPlayerController);
//   }

//   void _setupDataSource() {
//     var filePath = FILEPATH[widget.url].path;
//     File file = File(filePath);

//     List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
//     BetterPlayerDataSource dataSource =
//         BetterPlayerDataSource.memory(bytes, videoExtension: "mp4");
//     _betterPlayerController.setupDataSource(dataSource);
//   }
// }
