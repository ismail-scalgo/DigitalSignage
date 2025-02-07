import 'dart:async';

import 'package:digitalsignange/Costants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Center(
        child: Text(
          "No Internet Connection",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class MediaDownloadingScreen extends StatefulWidget {
  const MediaDownloadingScreen({super.key});

  @override
  State<MediaDownloadingScreen> createState() => _MediaDownloadingScreenState();
}

class _MediaDownloadingScreenState extends State<MediaDownloadingScreen> {
  Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  bool isOnline = true;

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    print("media listeningggggggg");
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isOnline
        ? mediaDownloadingWidget(height, width)
        : NoInternetScreen();
  }

  Widget mediaDownloadingWidget(double height, double width) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingWidget(height, width),
              Text(
                "FILES DOWNLOADING",
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: 0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateConnectionStatus(List<ConnectivityResult> result) async {
    if (await isOffline()) {
      setState(() {
        isOnline = false;
      });
    } else {
      setState(() {
        isOnline = true;
      });
    }
  }

  Widget LoadingWidget(double height, double width) {
    return Center(
        child: Container(
            width: width / 10,
            height: width / 10,
            child: Lottie.asset('assets/loading3.json')));
  }
}
