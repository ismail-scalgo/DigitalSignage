// import 'package:digitalsignange/UI/VIDEOLOCK.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';

// class Mymediakitvideoplayer extends StatefulWidget {
//   String url;

//    Mymediakitvideoplayer({required this.url});

//   @override
//   State<Mymediakitvideoplayer> createState() => _MymediakitvideoplayerState();
// }

// class _MymediakitvideoplayerState extends State<Mymediakitvideoplayer> {

//   bool isLoading=true;


//   late final player = Player();
//   late final controllerweb = VideoController(
//     player,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return isLoading ? Center(child: Text("INITIALISING"),) : SizedBox(
//             child: Video(
//               fit: BoxFit.fill,
//               controller: controllerweb,
//               controls: (state) {
//                 return Center();
//               },
//             ),
//           );
//   }


//   void initializeVideoplayer() async {

//     ISVIDEOLOCKED=true;
//      var file = await DefaultCacheManager().getSingleFile(widget.url);

//    await player.open(
//       Media( 
//         file.path
//       ),
//       play: true,
//     );
//     // player.setVolume(1);
   
//     await controllerweb.player.setPlaylistMode(PlaylistMode.loop);
//      controllerweb.player.play();
//     setState(() {
//       isLoading = false;
//     });

//     ISVIDEOLOCKED=false;


//   }

//   void loadvideo() async
//   {
//       if(!ISVIDEOLOCKED)
//       {
//         initializeVideoplayer();
//       }
//       else
//       {
//        await Future.delayed(Duration(milliseconds: 100));
//        loadvideo();
//       }


//   }
// }