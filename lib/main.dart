// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:digitalsignange/UI/ControllerWidget.dart';
import 'package:digitalsignange/UI/LaunchingScreen.dart';
import 'package:digitalsignange/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:digitalsignange/UI/LoginScreen.dart';
import 'package:digitalsignange/UI/NewLoginScreen.dart';
import 'package:digitalsignange/UI/SplashScreen.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:digitalsignange/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LayoutblocBloc()),
    BlocProvider(create: (context) => RegisterblocBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AnimatedSplashScreen(
      splash: SplashScreen(),
      nextScreen: ScreenCodeScreen(),
      backgroundColor: Colors.black,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
    ));
    // return MaterialApp(home: ScreenCodeScreen());
  }
}
