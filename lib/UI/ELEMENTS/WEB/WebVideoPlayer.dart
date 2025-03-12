// import 'package:flutter/material.dart';

// import 'package:lottie/lottie.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:video_player/video_player.dart';

// class WebVideoPlayer extends StatefulWidget {
//   String url;
//   WebVideoPlayer({required this.url});
//   @override
//   State<WebVideoPlayer> createState() => WebVideoPlayerState();
// }

// class WebVideoPlayerState extends State<WebVideoPlayer> {
//   bool isLoading = true;

//   late VideoPlayerController controller;

//   late final player = Player();
//   late final controllerweb = VideoController(
//     player,
//   );

//   @override
//   void initState() {
//     super.initState();
//     loadWeb();
//   }

//   @override
//   void dispose() {
//     controllerweb.player.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Center(
//         child: isLoading ? LoadingWidget(height, width) : getplayer());
//   }

//   Widget getplayer() {
//     return SizedBox(
//       child: Video(
//         fit: BoxFit.fill,
//         controller: controllerweb,
//         controls: (state) {
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
//     // player.setVolume(1);
//     controllerweb.player.play();
//     controllerweb.player.setPlaylistMode(PlaylistMode.loop);
//     setState(() {
//       isLoading = false;
//     });

//     Future.delayed(Duration(seconds: 5), () {
//       //controllerweb.player.setVolume(1);
//       print("VOLUME INCREASED");
//     });
//   }

//   Widget LoadingWidget(double height, double width) {
//     return Center(
//         child: Container(
//             width: width / 10,
//             height: width / 10,
//             child: Lottie.asset('assets/loading3.json')));
//   }
// }
