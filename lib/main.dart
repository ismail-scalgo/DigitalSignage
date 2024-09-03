// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:digitalsignange/UI/LaunchingScreen.dart';
import 'package:digitalsignange/BLOC/LayoutBloc/layoutbloc_bloc.dart';
import 'package:digitalsignange/UI/LoginScreen.dart';
import 'package:digitalsignange/UI/RegisterScreen.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
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
    return MaterialApp(home: LoginScreen());
  }
}

// class MyScreen extends StatefulWidget {
//   const MyScreen({Key? key}) : super(key: key);
//   @override
//   State<MyScreen> createState() => MyScreenState();
// }

// class MyScreenState extends State<MyScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log("width = ${MediaQuery.of(context).size.width}");
//     log("height = ${MediaQuery.of(context).size.height}");
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SizedBox(
//           width: width,
//           height: height,
//           child: Center(
//               child: Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Container(
//               // color: Colors.green,
//               height: height,
//               width: width,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       CustomVideoPLayer(
//                           width: 550,
//                           height: 350,
//                           url:
//                               'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'),
//                       CustomVideoPLayer(
//                           width: 547,
//                           height: 350,
//                           url:
//                               'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4')
//                       // ImageScreen(
//                       //     width: 200, height: 300, url: 'assets/burger.jpeg'),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       CustomVideoPLayer(
//                           width: 1097,
//                           height: 250,
//                           url:
//                               'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4')
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           )),
//         ),
//       ),
//     );
//   }
// }
