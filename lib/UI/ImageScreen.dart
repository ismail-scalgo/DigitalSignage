// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, avoid_unnecessary_containers, unnecessary_this



import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageScreen extends StatefulWidget {
  String url;
  
  // double width;
  // double height;
  ImageScreen({required this.url});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool isLoad = true;
  late File imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }
  @override
  Widget build(BuildContext context) {

    return
     isLoad ? Center(child: CircularProgressIndicator()) : Container(
      child: Image.file(imageFile, fit: BoxFit.fill)
    );
  }

  void load() async{
    imageFile = await DefaultCacheManager().getSingleFile(widget.url);
    isLoad = false;
    setState(() {
      
    });
  }
}
