// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:player/ControllerWidget.dart';
import 'package:player/UI/ControllerScreen.dart';
import 'package:player/UI/LaunchingScreen.dart';
import 'package:player/BLOC/LayoutBloc/layoutbloc_bloc.dart';

import 'package:player/UI/ScreenCodeScreen.dart';
import 'package:player/UI/ScreenDeleted.dart';
import 'package:player/UI/SplashScreen.dart';
import 'package:player/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:player/Utils.dart';
import 'package:player/packagetest.dart';
import 'package:player/test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:hive/hive.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  // MediaKit.ensureInitialized();

  FullScreenWindow.setFullScreen(true);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LayoutblocBloc()),
    BlocProvider(create: (context) => RegisterblocBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DebugPrint("MAIN METHOD CALLEDDD");
    return MaterialApp(
        home: AnimatedSplashScreen(
      splash: SplashScreen(),
      // nextScreen: ScreenCodeScreen(),
      nextScreen: Controllerscreen(),
      backgroundColor: Colors.black,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
    ));

    // return MaterialApp(home: ScreenDeletedScreen());
  }
}
