import 'package:digitalsignange/Costants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart';

// import 'package:video_player_media_kit/video_player_media_kit.dart';

class MediaKitWebPlayer extends StatefulWidget {
  String url;
  MediaKitWebPlayer({required this.url});
  @override
  State<MediaKitWebPlayer> createState() => MediaKitWebPlayerState();
}

class MediaKitWebPlayerState extends State<MediaKitWebPlayer> {
  bool isLoading = true;



  late final player = Player(configuration: PlayerConfiguration(muted: true));
  late final controllerweb = VideoController(
    player,
  );

  @override
  void initState() {
    super.initState();
  loadWeb();
  }

  @override
  void dispose() {
 
      controllerweb.player.dispose();
  

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
    return 
        SizedBox(
            child: Video(
              fit: BoxFit.fill,
              controller: controllerweb,
              controls: (state) {
                return Center();
              },
            ),
          );
        
  }

  void loadWeb() async {
    player.open(
      Media(
        widget.url,
      ),
      play: true,
    );
    // player.setVolume(1);
   
   await controllerweb.player.setVolume(0);
  await  controllerweb.player.setPlaylistMode(PlaylistMode.loop);
     controllerweb.player.play();
    setState(() {
      isLoading = false;
    });


  }

}
