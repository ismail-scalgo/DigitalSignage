// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, unnecessary_import, duplicate_import, unused_import, prefer_interpolation_to_compose_strings, sort_child_properties_last

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
import 'package:digitalsignange/UI/LoginScreen.dart';
import 'package:digitalsignange/UI/SingleZoneView.dart';
import 'package:digitalsignange/UI/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchingScreen extends StatefulWidget {
  String screenCode;
  LaunchingScreen({required this.screenCode});

  @override
  State<LaunchingScreen> createState() => _LyoutScreenState();
}

class _LyoutScreenState extends State<LaunchingScreen> {
  double factor = 1.59;

  bool isLoad = true;
  bool isButtonVisible = true;
  bool isShrink = false;

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
      // backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: () {
          // setState(() {
          //   isShrink = true;
          // });

          apiBloc.add(visibleButton(isvisible: true));
          Future.delayed(Duration(seconds: 3), () {
            apiBloc.add(visibleButton(isvisible: false));
          });
          // apiBloc.add(ShrinkView(isvisible: true));
        },
        child: Container(
          color: Colors.transparent,
          width: width,
          height: height,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: isShrink ? width * 0.9 : width,
                  height: isShrink ? height * 0.7 : height,
                  child: Center(
                    child: BlocConsumer<LayoutblocBloc, LayoutblocState>(
                      buildWhen: (previous, current) {
                        return current is! DisplayButton;
                      },
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
                          return Center(
                              child: Container(
                                  height: height / 3,
                                  width: width / 4.5,
                                  child: Lottie.asset('assets/Shoes.json')));
                        }
                        return Center(
                          child: Container(
                              height: height / 3,
                              width: width / 4.5,
                              child: Lottie.asset('assets/Shoes.json')),
                        );
                      },
                    ),
                  ),
                ),
              ),
              BlocConsumer<LayoutblocBloc, LayoutblocState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is DisplayButton) {
                    return Visibility(
                      visible: state.isvisible,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Align(
                          child: InkWell(
                            child: Container(
                              height: 35,
                              width: width / 7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 143, 174, 243)),
                              child: Center(
                                  child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                            onTap: () {
                              showMyDialog(context);
                            },
                          ),
                          // child: ElevatedButton(
                          //     onPressed: () {
                          //       showMyDialog(context);
                          //     },
                          //     child: Text("Logout")),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    );
                  }
                  return Center();
                },
              ),
              if (isShrink)
                Positioned(
                  // right: 10,
                  left: width,
                  // right: width,
                  width: width,
                  bottom: height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isShrink = false;
                          });
                        },
                        child: Text('Button 1'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button 2 press
                        },
                        child: Text('Button 2'),
                      ),
                    ],
                  ),
                ),
            ],
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

  void showDialogBox(BuildContext content) {
    PanaraConfirmDialog.show(
      context,
      title: "Hello",
      message: "This is the PanaraConfirmDialog",
      confirmButtonText: "Confirm",
      cancelButtonText: "Cancel",
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: false,
      color: Colors.black,
      textColor: Colors.black,
      buttonTextColor: Colors.black,
    );
    // PanaraCustomDialog.show(
    //   context,
    //   children: [
    //     Text(
    //       "Hello",
    //       style: TextStyle(
    //         fontSize: 20,
    //       ),
    //       textAlign: TextAlign.center,
    //     ),
    //     Text(
    //       "This is the PanaraCustomDialog",
    //       style: TextStyle(fontSize: 16),
    //       textAlign: TextAlign.center,
    //     ),
    //     // Add your own widgets here
    //   ],
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   backgroundColor: Colors.white,
    //   margin: EdgeInsets.all(20),
    //   padding: EdgeInsets.all(20),
    //   barrierDismissible: false,
    // );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Logout')),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Center(child: Text('Do you want to logout ?')),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    // CircularProgressIndicator();
                    // Future.delayed(Duration(seconds: 2), () {
                    clearData();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                    // });
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void loadLayout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // return
    print("code = ${prefs.getString('screenCode')}");
    apiBloc.add(FetchApi(screenCode: widget.screenCode));
  }
}
