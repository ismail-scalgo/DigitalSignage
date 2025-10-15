// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, unnecessary_import, duplicate_import, unused_import, prefer_interpolation_to_compose_strings, sort_child_properties_last, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:player/Costants.dart';
import 'package:player/MODELS/XCompositionModel.dart';
import 'package:player/UI/ELEMENTS/COMMON/ImageView.dart';
import 'package:player/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:player/REPOSITORIES/LayoutRepo.dart';
import 'package:player/MODELS/MediaDetailModel.dart';
import 'package:player/MODELS/ResponseDataModel.dart';
import 'package:player/MODELS/ZoneModel.dart';

import 'package:player/UI/ScreenCodeScreen.dart';
import 'package:player/UI/NoBroadCastScreen.dart';

import 'package:player/UI/NoInternetScreen.dart';
import 'package:player/UI/ScreenDeleted.dart';

import 'package:player/UI/SingleZoneController.dart';
import 'package:player/UI/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:screenshot/screenshot.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:toastification/toastification.dart';

import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LaunchingScreen extends StatefulWidget {
  String screenCode;
  LaunchingScreen({required this.screenCode});

  @override
  State<LaunchingScreen> createState() => _LyoutScreenState();
}

class _LyoutScreenState extends State<LaunchingScreen> {
  double factor = 1.59;
  ScreenshotController screenshotController = ScreenshotController();

  // WidgetsToImageController controller = WidgetsToImageController();

  bool isLoad = true;
  bool isButtonVisible = true;
  bool isShrink = false;
  late LayoutblocBloc apiBloc;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    // print(Theme.of(context).platform);
    // if (Theme.of(context).platform == TargetPlatform.android) {
    //       print(Theme.of(context).platform);
    //     }
    WakelockPlus.enable();
    apiBloc = BlocProvider.of<LayoutblocBloc>(context);
    loadLayout();
    // late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
    // connectivitySubscription = connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  void dispose() {
    WakelockPlus.disable();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("platfoooooooooooooooooooooooorm = ${Theme.of(context).platform}");
    if (Theme.of(context).platform == TargetPlatform.android) {
      print(Theme.of(context).platform);
    }
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("width = $width");
    print("height = $height");
    factor = width / height;
    final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
    return PopScope(
      // onPopInvokedWithResult: (didPop, result) {
      //   _onWillPop(context);
      //   print("platfoooooooooooooooooooooooorm = ${Theme.of(context).platform}");
      // },
      // onPopInvoked: (didPop) {
      //   print("platfoooooooooooooooooooooooorm = ${Theme.of(context).platform}");
      // },
      child: Scaffold(
        key: drawerKey,
        backgroundColor: Colors.black,
        // endDrawer: Drawer(
        //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        //   child: ListView(
        //     children: [
        //       DrawerHeader(
        //         decoration: BoxDecoration(
        //           color: Color.fromARGB(255, 0, 0, 0),
        //         ),
        //         curve: Curves.fastOutSlowIn,
        //         child: Center(
        //           child: Text(
        //             "${widget.screenCode}",
        //             style: TextStyle(
        //                 color: Colors.white, fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //       ),
        //       ListTile(
        //         title: Center(
        //             child: Text(
        //           'Logout',
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: const Color.fromARGB(255, 0, 0, 0)),
        //         )),
        //         onTap: () {
        //           showMyDialog(context);
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        body: GestureDetector(
          onLongPress: () {
            drawerKey.currentState?.openEndDrawer();
            // apiBloc.add(visibleButton(isvisible: true));
            // Future.delayed(Duration(seconds: 3), () {
            //   apiBloc.add(visibleButton(isvisible: false));
            // });
          },
          child: Screenshot(
            controller: screenshotController,
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
                            if (current is TakeScreenState ||
                                current is DownloadProgressState) {
                              return false;
                            }

                            return (current is! DisplayButton);
                          },
                          listener: (context, state) async {
                            if (state is LogoutState) {
                              // LoadingWidget(height, width);
                              // await Future.delayed(Duration(seconds: 2));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenDeletedScreen()),
                                  (route) => false);
                            }

                            if (state is TakeScreenState) {
                              print("TAKE SCREEN SHOT CALLED ON LISTENER");


          await screenshotController.capture(delay: const Duration(milliseconds: 500)).then((Uint8List? image) async {
      if (image != null) {
      

     apiBloc.add(UploadScreenShootEvent(
                                    capturedimage: image,screenshoot_id: state.screenshoot_id));
       
      }
    });
                              

                              // controller.capture().then((capturedImage) async {
                              //   print("screen shot taked sucessfully");
                              //   apiBloc.add(UploadScreenShootEvent(
                              //       capturedimage: capturedImage!));
                              // }).catchError((onError) {
                              //   print(onError);
                              // });
                            }
                            // if (state is MediaLoadingState) {
                            //   MaterialPageRoute(
                            //           builder: (context) => MediaDownloadingScreen());
                            // }
                          },
                          builder: (context, state) {
                            print("Builder called in UI");
                            print(state);
                            if (state is NoBroadcastState) {
                              // return Center(child: Text("no broad"));
                              return NoBroadCastScreen();
                            }
                            if (state is OfflineState) {
                              return NoInternetScreen();
                            }
                            if (state is MediaLoadingState) {
                              return MediaDownloadingScreen();
                            }
                            print("state is $state");
                            if (state is DisplayLayout) {
                              // connectivitySubscription.cancel();
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
                                quarterTurns = 3;
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
                                quarterTurns = 1;
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
                              return Container(
                                color: Colors.black,
                                child: Center(
                                  child: LoadingWidget(height, width),
                                ),
                              );
                            }
                            if (state is DefaultScreen) {
                              // loadPlayer();
                              return Container(
                                width: width,
                                height: height,
                                color: Colors.black,
                                child: Stack(
                                  children: [
                                    // Container(
                                    //   child: VideoPlayer(controller),
                                    // ),
                                    // Container(
                                    //   color: Color.fromARGB(255, 44, 43, 43)
                                    //       .withOpacity(0.8),
                                    //   // decoration: BoxDecoration(
                                    //   //     color: Color.fromARGB(255, 44, 43, 43)
                                    //   //         .withOpacity(0.8)),
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Text(
                                              //   "NO",
                                              //   style: GoogleFonts.protestStrike(
                                              //       textStyle: TextStyle(
                                              //           // color: Color.fromARGB(255, 65, 51, 51),
                                              //           color: Color.fromARGB(
                                              //               255, 216, 213, 213),
                                              //           fontSize: width > height
                                              //               ? width / 12
                                              //               : height / 12,
                                              //           fontWeight:
                                              //               FontWeight.w500),
                                              //       height: 0.8),
                                              // ),
                                              // Text(
                                              //   "BROADCAST.",
                                              //   style: GoogleFonts.protestStrike(
                                              //     textStyle: TextStyle(
                                              //         color: Color.fromARGB(
                                              //             255, 218, 46, 15),
                                              //         fontSize: width > height
                                              //             ? width / 17
                                              //             : height / 17,
                                              //         fontWeight: FontWeight.bold,
                                              //         letterSpacing: 0),
                                              //   ),
                                              // ),
                                              Countdown(
                                                // controller: _controller,
                                                seconds: state.countdown,
                                                build: (_, double time) =>
                                                    Column(
                                                  children: [
                                                    // Text(
                                                    //   "NEXT IN",
                                                    //   style: TextStyle(
                                                    //       letterSpacing: 18,
                                                    //       fontSize: 18,
                                                    //       fontWeight:
                                                    //           FontWeight.bold,
                                                    //       color: Color.fromARGB(
                                                    //           255, 255, 217, 0)),
                                                    // ),
                                                    Text(
                                                      "BROADCAST IN",
                                                      style:GoogleFonts.protestStrike(
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: width / 17,
                      letterSpacing: 3),
                ),
                                                      // style: TextStyle(
                                                      //     color: Color.fromARGB(
                                                      //         255,
                                                      //         255,
                                                      //         255,
                                                      //         255),
                                                      //     fontSize:
                                                      //         width > height
                                                      //             ? width / 17
                                                      //             : height / 17,
                                                      //     fontWeight:
                                                      //         FontWeight.bold,
                                                      //     fontFamily:
                                                      //         'MyCustomFont',
                                                      //     letterSpacing: 0),
                                                      // ),
                                                    ),
                                                    
                                                Container(
      // Fix the size to avoid movement of the widget itself
      width: width,
      child: Center(
        child: AutoSizeText(
          state.countdown > 86400
              ? formatDaysTime(time.toInt())
              : formatHoursTime(time.toInt()),
        
          style: GoogleFonts.robotoMono(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: width / 17,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
              letterSpacing: 1,
            ),
          ),
          maxFontSize: (width / 17).floorToDouble(), // or round to nearest 0.5
        stepGranularity: 0.5,
          maxLines: 1,
          minFontSize: 10,
          // maxFontSize: width / 17,
          // stepGranularity: 0.5,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    
                                                      // style: GoogleFonts
                                                      //     .playfairDisplay(
                                                      //   textStyle: TextStyle(
                                                      //       color: Color
                                                      //           .fromARGB(
                                                      //               255,
                                                      //               255,
                                                      //               254,
                                                      //               254),
                                                      //       fontSize: 25,
                                                      //       fontWeight:
                                                      //           FontWeight.w100,
                                                      //       letterSpacing: 5),
                                                      // ),
                                                      // style: TextStyle(
                                                      //     fontSize: 25,
                                                      //     fontWeight:
                                                      //         FontWeight.bold,
                                                      //     color: const Color.fromARGB(255, 255, 255, 255)),
                                                    ),
                                                  ],
                                                ),
                                                interval: Duration(seconds: 1),
                                                onFinished: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'BROADCAST LIVE'),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                              // return Center(
                              //     child: Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              // children: [
                              //   Container(
                              //       height: height / 3,
                              //       width: width / 3.5,
                              //       child: Lottie.asset('assets/Shoes.json')),
                              //   Countdown(
                              //     // controller: _controller,
                              //     seconds: state.countdown,
                              //     build: (_, double time) => Column(
                              //       children: [
                              //         Text(
                              //           "NEXT IN",
                              //           style: TextStyle(
                              //               letterSpacing: 18,
                              //               fontSize: 18,
                              //               fontWeight: FontWeight.bold,
                              //               color:
                              //                   Color.fromARGB(255, 255, 217, 0)),
                              //         ),
                              //         Text(
                              //           formatTime(time.toInt()),
                              //           style: TextStyle(
                              //               fontSize: 25,
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.blue),
                              //         ),
                              //       ],
                              //     ),
                              //     interval: Duration(seconds: 1),
                              //     onFinished: () {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           content: Text('BROADCAST LIVE'),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ],
                              // ));
                            }
                            return Container(
                              // color: Colors.blue,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              child: Center(
                                child: LoadingWidget(height, width),
                                // child: Container(
                                //     height: height / 3,
                                //     width: width / 3.5,
                                //     child: Lottie.asset('assets/Shoes.json')),
                              ),
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
                                      color: const Color.fromARGB(
                                          255, 65, 51, 51)),
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

                  BlocConsumer<LayoutblocBloc, LayoutblocState>(
                    listener: (context, state) {},
                    buildWhen: (previous, current) {
                      return current is DownloadProgressState;
                    },
                    builder: (context, state) {
                      print("INSIDE DOWNLOAD PROGRESS STATE");
                      if (state is DownloadProgressState && state.isVisible) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      child: Text(
                                    state.markerText,
                                    style: TextStyle(
                                        color: Colors.amber, fontSize: 18),
                                  )),
                                  LinearProgressBar(
                                    maxSteps: 100,
                                    progressType: LinearProgressBar
                                        .progressTypeLinear, // Use Linear progress
                                    currentStep: state.progress,
                                    progressColor:
                                        const Color.fromARGB(255, 255, 0, 128),
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.circular(10), //  NEW
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center();
                      }
                    },
                  )
                  // if (isShrink)
                  //   Positioned(
                  //     // right: 10,
                  //     left: width,
                  //     // right: width,
                  //     width: width,
                  //     bottom: height * 0.1,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         ElevatedButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               isShrink = false;
                  //             });
                  //           },
                  //           child: Text('Button 1'),
                  //         ),
                  //         SizedBox(height: 10),
                  //         ElevatedButton(
                  //           onPressed: () {
                  //             // Handle button 2 press
                  //           },
                  //           child: Text('Button 2'),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<StaggeredGridTile> buildGrids(LayoutData layoutdata) {
    List<StaggeredGridTile> staggeredList = [];
    layoutdata.zoneData?.forEach((zonedata) {
      StaggeredGridTile tile = StaggeredGridTile.count(
        crossAxisCellCount: zonedata.widthPercent,
        mainAxisCellCount: zonedata.heightPercent / factor,
        child: SingleZoneController(
          zonedata: zonedata,
        
          broadcast_id: layoutdata.id.toString(),
        ),
      );

      staggeredList.add(tile);
    });

    return staggeredList;
  }

  void showMyDialog(BuildContext context) async {
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
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    print("logout presseed");
                    apiBloc.add(LogoutEvent());
                    // clearData();
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ScreenCodeScreen()),
                    //     (route) => false);
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

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Do you really want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog returns null
  }

  String formatDaysTime(int totalSeconds) {
    // Calculate the number of days, hours, minutes, and seconds
    int days = totalSeconds ~/ (24 * 3600);
    totalSeconds %= (24 * 3600);

    int hours = totalSeconds ~/ 3600;
    totalSeconds %= 3600;

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return '${days.toString().padLeft(2, '0')} : ${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  String formatHoursTime(int totalSeconds) {
    // Calculate the number of days, hours, minutes, and seconds
    int days = totalSeconds ~/ (24 * 3600);
    totalSeconds %= (24 * 3600);

    int hours = totalSeconds ~/ 3600;
    totalSeconds %= 3600;

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
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

  Widget LoadingWidget(double height, double width) {
    return Center(
        child: Container(
            width: width / 10,
            height: width / 10,
            child: Lottie.asset('assets/loading3.json')));
  }

  void loadLayout() async {
    print("loaded");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // return
    print("code = ${prefs.getString('screenCode')}");
    print("fetch api added");
    apiBloc.add(FetchApi(screenCode: widget.screenCode));
  }

  void checkConnectivity() async {
    if (await isOffline()) {
      showToast(context, "No Internet Connection");
      apiBloc.add(OfflineEvent());
    }
  }

  void showToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      foregroundColor: Color.fromARGB(255, 255, 255, 255),
      type: ToastificationType.success,
      style: ToastificationStyle.simple,
      title: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
