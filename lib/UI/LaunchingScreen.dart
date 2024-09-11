// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, unnecessary_import, duplicate_import, unused_import, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/MODELS/XCompositionModel.dart';
import 'package:digitalsignange/UI/ImageScreen.dart';
import 'package:digitalsignange/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:digitalsignange/REPOSITORIES/LayoutRepo.dart';
import 'package:digitalsignange/MODELS/MediaDetailModel.dart';
import 'package:digitalsignange/MODELS/ResponseDataModel.dart';
import 'package:digitalsignange/MODELS/ZoneModel.dart';
import 'package:digitalsignange/UI/SingleZoneView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LaunchingScreen extends StatefulWidget {
  LaunchingScreen({super.key});

  @override
  State<LaunchingScreen> createState() => _LyoutScreenState();
}

class _LyoutScreenState extends State<LaunchingScreen> {
  double factor = 1.59;

  bool isLoad = true;

  late LayoutblocBloc apiBloc;

  @override
  void initState() {
    super.initState();
    apiBloc = BlocProvider.of<LayoutblocBloc>(context);
    loadLayout();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("width = $width");
    print("height = $height");
    factor = width / height;
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: BlocConsumer<LayoutblocBloc, LayoutblocState>(
            listener: (context, state) {},
            builder: (context, state) {
              print("state is $state");
              if (state is DisplayLayout) {
                if (state.layoutdata.oreintation_angle == 0 ||
                    state.layoutdata.oreintation_angle == 180) {
                  gwidth = width;
                  gheight = height;
                } else {
                  gwidth = height;
                  gheight = width;
                }

                factor = gwidth / gheight;

                int quarterTurns = 0;

                if (state.layoutdata.oreintation_angle >= 0 &&
                    state.layoutdata.oreintation_angle < 90) {
                  gwidth = width;
                  gheight = height;

                  quarterTurns = 0;
                }

                if (state.layoutdata.oreintation_angle >= 90 &&
                    state.layoutdata.oreintation_angle < 180) {
                  gwidth = height;
                  gheight = width;
                  quarterTurns = 1;
                }

                if (state.layoutdata.oreintation_angle >= 180 &&
                    state.layoutdata.oreintation_angle < 270) {
                  gwidth = width;
                  gheight = height;
                  quarterTurns = 2;
                }

                if (state.layoutdata.oreintation_angle >= 270 &&
                    state.layoutdata.oreintation_angle < 360) {
                  gwidth = height;
                  gheight = width;
                  quarterTurns = 3;
                }
                factor = gwidth / gheight;

                return RotatedBox(
                  quarterTurns: quarterTurns,
                  child: StaggeredGrid.count(
                      crossAxisCount: 100,
                      children: buildGrids(state.layoutdata)),
                );
              }
              if (state is DefaultScreen) {
                return Container(
                  color: Colors.black,
                  child: Text("Digital Signange"),
                );
                // return Center(
                //   child: Text("DIGITAL SIGNAGE"),
                // );
              }
              return Center(
                child: Text("Center...."),
              );
            },
          ),
        ),
      ),
    );
  }

  // List<StaggeredGridTile> displayGrids(Map<int, MediaDetails> layoutMap) {
  //   List<MediaDetails> layoutDetails = [];
  //   List<StaggeredGridTile> staggeredList = [];
  //   staggeredList.clear();
  //   layoutDetails.clear();
  //   layoutDetails = layoutMap.values.toList();

  //   for (int index = 0; index < layoutDetails.length; index++) {
  //     Widget currentWidget = BlocConsumer<LayoutblocBloc, LayoutblocState>(
  //       listener: (context, state) {},
  //       buildWhen: (previous, current) {
  //         DisplayLayout previousState = previous as DisplayLayout;
  //         DisplayLayout currentState = current as DisplayLayout;
  //         return previousState.mediaMap[index + 1]!.currentMediaPosition !=
  //             currentState.mediaMap[index + 1]!.currentMediaPosition;
  //       },
  //       builder: (context, state) {
  //         return SingleZoneView(
  //             details: (state as DisplayLayout).mediaMap[index + 1]!);
  //       },
  //     );
  //     var count = StaggeredGridTile.count(
  //         crossAxisCellCount: layoutDetails[index].width,
  //         mainAxisCellCount: layoutDetails[index].height / factor,
  //         child: currentWidget);
  //     staggeredList.add(count);
  //   }
  //   return staggeredList;
  // }

  List<StaggeredGridTile> buildGrids(LayoutData layoutdata) {
    List<StaggeredGridTile> staggeredList = [];
    layoutdata.zoneData.forEach((zonedata) {
      StaggeredGridTile tile = StaggeredGridTile.count(
        crossAxisCellCount: zonedata.widthPercent,
        mainAxisCellCount: zonedata.heightPercent / factor,
        child: SingleZoneView(zonedata: zonedata),
      );

      staggeredList.add(tile);
    });

    return staggeredList;
  }

  void loadLayout() {
    apiBloc.add(FetchApi());
  }
}
