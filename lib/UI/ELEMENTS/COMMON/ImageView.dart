// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, avoid_unnecessary_containers, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lottie/lottie.dart';

class ImageScreen extends StatefulWidget {
  String url;

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
  void didUpdateWidget(covariant ImageScreen oldWidget) {
    load();
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return isLoad
        ? Center(
            child: Center(
                child: Container(
                    width: width / 10,
                    height: width / 10,
                    child: Lottie.asset('assets/loading3.json'))))
        : Container(child: Image.file(imageFile, fit: BoxFit.contain));
  }

  void load() async {
    imageFile = await DefaultCacheManager().getSingleFile(widget.url);
    isLoad = false;
    setState(() {});
  }

  Widget LoadingWidget(double height, double width) {
    return Center(
        child: Container(
            width: width / 10,
            height: width / 10,
            child: Lottie.asset('assets/loading3.json')));
  }
}
