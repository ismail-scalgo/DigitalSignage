import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng mark1 = LatLng(37.32, 4.132);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: width,
        height: height,
        child: GoogleMap(
            initialCameraPosition: CameraPosition(target: mark1, zoom: 13)),
      )),
    );
  }
}
