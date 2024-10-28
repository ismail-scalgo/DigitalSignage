
import 'package:digitalsignange/UI/BetterPLayerCacheObject.dart';
import 'package:flutter/material.dart';

import 'package:better_player/better_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class BetterVideoPlayer extends StatefulWidget {
  String url;
  int zoneid;
  double aspectratio;
 BetterVideoPlayer({ required this.url, required this.zoneid,required this.aspectratio});

  @override
  State<BetterVideoPlayer> createState() => _BetterVideoPlayerState();
}

class _BetterVideoPlayerState extends State<BetterVideoPlayer> {

late BetterPlayerController _betterPlayerController;
bool isloading=true;
  @override
  void initState() {

load();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:1,
      
      child:  BetterPlayer(controller: _betterPlayerController));
  }

  void load() {

    if(BETTERPLAYERCACHEOBJECTS[widget.zoneid] == null)
    {

       var file = FILEPATH[widget.url];
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        
        
       file);
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(handleLifecycle: false, autoDispose: false,autoPlay: true,
     fit: BoxFit.fill,
       aspectRatio: widget.aspectratio,
        controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false)
        ),
      
        betterPlayerDataSource: betterPlayerDataSource);

        BETTERPLAYERCACHEOBJECTS[widget.zoneid]=_betterPlayerController;




    }

    else
    {
    var file = FILEPATH[widget.url];
     BETTERPLAYERCACHEOBJECTS[widget.zoneid]!.pause();
      BETTERPLAYERCACHEOBJECTS[widget.zoneid]!.setupDataSource(BetterPlayerDataSource.file(file));
      _betterPlayerController= BETTERPLAYERCACHEOBJECTS[widget.zoneid]!;
     
    }
    BETTERPLAYERCACHEOBJECTS[widget.zoneid]!.setLooping(true);


    

     
  }
  
}