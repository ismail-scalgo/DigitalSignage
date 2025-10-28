import 'package:player/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';

import 'package:player/UI/LaunchingScreen.dart';
import 'package:player/UI/NoInternetScreen.dart';
import 'package:display_metrics/display_metrics.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:player/Utils.dart';

class PreScreenCodeScreen extends StatefulWidget {
  const PreScreenCodeScreen({super.key});

  @override
  State<PreScreenCodeScreen> createState() => _PreScreenCodeScreenState();
}

class _PreScreenCodeScreenState extends State<PreScreenCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DisplayMetricsWidget(child: ScreenCodeScreen()));
  }
}

class ScreenCodeScreen extends StatefulWidget {
  const ScreenCodeScreen({super.key});

  @override
  State<ScreenCodeScreen> createState() => _ScreenCodeScreenState();
}

class _ScreenCodeScreenState extends State<ScreenCodeScreen> {
  late RegisterblocBloc registerBloc;

  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    DebugPrint("screen code screeeeeeeeeeeeen");

    registerBloc = BlocProvider.of<RegisterblocBloc>(context);
    registerBloc.add(AddContext(context: context));
    registerBloc.add(InterNetStatusEvent());
  }

  @override
  void didChangeDependencies() {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<RegisterblocBloc, RegisterblocState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is LaunchScreen) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LaunchingScreen(screenCode: state.code),
                ),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is DisplayScreenCodeState) {
              return pairDeviceWidget(state.screenCode);
            }
            if (state is OfflineState) {
              return NoInternetScreen();
            }
            return LoadingWidget(height, width);
          },
        ),
      ),
    );
  }

  Widget pairDeviceWidget(String screencode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // transform: GradientRotation(0.3),
          tileMode: TileMode.mirror,
          colors: [
            Color.fromARGB(255, 43, 2, 109),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 43, 2, 109),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height / 15),
          Container(
            // color: Colors.white,
            height: height / 1.2,
            width: width / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pair device",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 190, 190, 190),
                    fontSize: 25,
                    // fontSize: width / 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "1. Login into www.zignflix.com",
                //"1. Login into www.test-zignflix.com/",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 190, 190, 190),
                    fontSize: 20,
                    // fontSize: width / 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "2. Click 'Add Screen' and enter the below screen code",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 190, 190, 190),
                    fontSize: 20,
                    // fontSize: width / 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  screencode,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 190, 190, 190),
                    fontSize: 50,
                    // fontSize: width / 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget LoadingWidget(double height, double width) {
    return Center(
      child: Container(
        width: width / 10,
        height: width / 10,
        child: Lottie.asset('assets/loading3.json'),
      ),
    );
  }
}
