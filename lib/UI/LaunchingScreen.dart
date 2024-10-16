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
import 'package:digitalsignange/UI/NoBroadcastScreen.dart';
import 'package:digitalsignange/UI/SingleZoneView.dart';
import 'package:digitalsignange/UI/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
    WakelockPlus.enable();
    apiBloc = BlocProvider.of<LayoutblocBloc>(context);
    loadLayout();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
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
                        print("Builder called in UI");
                        // if (state is NoBroadcastState) {
                        //   return Center(
                        //     child: Text(
                        //       "NO BROADCAST ON THIS SCREEN",
                        //       style: TextStyle(fontSize: 20),
                        //     ),
                        //   );
                        // }
                        if (state is NoBroadcastState) {
                          return NoBroadCastScreen();
                        }
                        print("state is $state");
                        if (state is DisplayLayout) {
                          if (state.layoutdata.oreintationAngle == 0 ||
                              state.layoutdata.oreintationAngle == 180) {
                            gwidth = width;
                            gheight = height;
                          } else {
                            gwidth = height;
                            gheight = width;
                          }
                          factor = gwidth / gheight;

                          int quarterTurns = 0;

                          if (state.layoutdata.oreintationAngle >= 0 &&
                              state.layoutdata.oreintationAngle < 90) {
                            gwidth = width;
                            gheight = height;

                            quarterTurns = 0;
                          }

                          if (state.layoutdata.oreintationAngle >= 90 &&
                              state.layoutdata.oreintationAngle < 180) {
                            gwidth = height;
                            gheight = width;
                            quarterTurns = 1;
                          }

                          if (state.layoutdata.oreintationAngle >= 180 &&
                              state.layoutdata.oreintationAngle < 270) {
                            gwidth = width;
                            gheight = height;
                            quarterTurns = 2;
                          }

                          if (state.layoutdata.oreintationAngle >= 270 &&
                              state.layoutdata.oreintationAngle < 360) {
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
                        if (state is TrasitionState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is DefaultScreen) {
                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: height / 3,
                                  width: width / 3.5,
                                  child: Lottie.asset('assets/Shoes.json')),
                              Countdown(
                                // controller: _controller,
                                seconds: state.countdown,
                                build: (_, double time) => Column(
                                  children: [
                                    Text(
                                      "NEXT IN",
                                      style: TextStyle(
                                          letterSpacing: 18,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 255, 217, 0)),
                                    ),
                                    Text(
                                      formatTime(time.toInt()),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                                interval: Duration(seconds: 1),
                                onFinished: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('BROADCAST LIVE'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ));
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                          // child: Container(
                          //     height: height / 3,
                          //     width: width / 3.5,
                          //     child: Lottie.asset('assets/Shoes.json')),
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
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Align(
                          child: InkWell(
                            child: Container(
                              height: 35,
                              width: width / 6.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(255, 65, 51, 51)),
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
    layoutdata.zoneData?.forEach((zonedata) {
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
                    print("button presseed");
                    apiBloc.add(LogoutEvent());
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

  String formatTime(int totalSeconds) {
    // Calculate the number of days, hours, minutes, and seconds
    int days = totalSeconds ~/ (24 * 3600);
    totalSeconds %= (24 * 3600);

    int hours = totalSeconds ~/ 3600;
    totalSeconds %= 3600;

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return '${days.toString().padLeft(2, '0')} : ${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  void loadLayout() async {
    print("loaded");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // return
    print("code = ${prefs.getString('screenCode')}");
    print("fetch api added");
    apiBloc.add(FetchApi(screenCode: widget.screenCode));
  }
}
