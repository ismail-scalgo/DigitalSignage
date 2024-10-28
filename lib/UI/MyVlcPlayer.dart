





// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// class MyVlcPlayer extends StatefulWidget {
//   double aspectratio;
//   String url;
//   MyVlcPlayer({required this.aspectratio,required this.url}) ;

//   @override
//   _MyVlcPlayerState createState() => _MyVlcPlayerState();
// }

// class _MyVlcPlayerState extends State<MyVlcPlayer> {

//   bool isloading=true;
  
// late  VlcPlayerController _videoPlayerController;

//   Future<void> initializePlayer() async {
//     var file = await DefaultCacheManager().getSingleFile(widget.url);

// _videoPlayerController = VlcPlayerController.file(
//       file,
//       hwAcc: HwAcc.auto,
//       autoInitialize: true,
//       autoPlay: true,
//       options: VlcPlayerOptions(),
//     );
    

   

//     isloading=false;
//     setState(() {
      
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//   initializePlayer();
//   }

//   @override
//   void dispose() async {
   
//     await _videoPlayerController.stopRendererScanning();
//     await _videoPlayerController.dispose();

//      super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return 
//           isloading ? CircularProgressIndicator(): VlcPlayer(
//             controller: _videoPlayerController,
//             aspectRatio: widget.aspectratio,
//             placeholder: Center(child: CircularProgressIndicator()),
//           );
        
//   }
// }
