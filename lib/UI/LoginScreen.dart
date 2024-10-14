// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:collection';
import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/UI/LaunchingScreen.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:digitalsignange/UI/RegisterScreen3.dart';
import 'package:digitalsignange/UI/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final screenCodeController = TextEditingController();
  late RegisterblocBloc loginBloc;
  String? screenCodeError;
  late StreamSubscription sub;
  final ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<RegisterblocBloc>(context);
    // checkConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context1) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     tileMode: TileMode.mirror,
          //     colors: [
          //       Color.fromARGB(255, 223, 124, 124),
          //       Color.fromARGB(255, 28, 91, 128)
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height / 2,
                width: width / 1,
                child: Lottie.asset('assets/loginAnim.json'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocConsumer<RegisterblocBloc, RegisterblocState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 50, right: 50),
                        child: Container(
                          width: width / 3.5,
                          child: TextField(
                            style: TextStyle(
                                color: Color.fromARGB(255, 58, 85, 206)),
                            controller: screenCodeController,
                            decoration: InputDecoration(
                                labelText: 'Screen Code',
                                errorText: state.screenCodeErr,
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 131, 154, 255)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 131, 154, 255)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 131, 154, 255)),
                                ),
                                focusColor: Color.fromARGB(255, 131, 154, 255),
                                errorBorder: UnderlineInputBorder(),
                                errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 58, 85, 206))),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: InkWell(
                      child: Container(
                        height: 35,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            tileMode: TileMode.mirror,
                            colors: [
                              Color.fromARGB(255, 153, 172, 255),
                              Color.fromARGB(255, 99, 128, 255)
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: Center(
                            child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: () {
                        validateInput(screenCodeController.text, context1);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      hoverColor: const Color.fromARGB(255, 224, 224, 224),
                      onTap: () {
                        registerClicked();
                      },
                      child: Text("Register",
                          style: TextStyle(
                            color: Color.fromARGB(255, 131, 154, 255),
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                  ),
                  BlocConsumer<RegisterblocBloc, RegisterblocState>(
                    listener: (context, state) {
                      if (state is LaunchScreen) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LaunchingScreen(screenCode: state.code)),
                            (route) => false);
                      }
                      if (state is DisplayRegistration) {
                        // Navigator.of(context).push(createRoute());
                        Navigator.of(context)
                            .push(FadeRoute(page: Registerscreen3()));
                      }
                      if (state is loginFailureState) {
                        print("failure state emittingggg");
                        Navigator.pop(context);
                        showToast(context, state.message);
                      }
                      if (state is LoginLoadingState) {
                        showLoad(context);
                      }
                    },
                    builder: (context, state) {
                      // if (state is LaunchScreen) {
                      //   return Center();
                      // }
                      return Center();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  void validateInput(String screenCode, BuildContext context1) async {
    if (await isOffline()) {
      showToast(context, "No Internet Connection");
      return;
    }
    loginBloc.add(LoginUser(screenCode: screenCode));
  }

  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Registerscreen3(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      foregroundColor: Color.fromARGB(255, 131, 154, 255),
      type: ToastificationType.success,
      style: ToastificationStyle.simple,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void registerClicked() async {
    if (await isOffline()) {
      showToast(context, "No Internet Connection");
      return;
    }
    loginBloc.add(ShowRegister());
  }

  void checkConnectivity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("code = ${prefs.getString('screenCode')}");
    String? screenCode = prefs.getString('screenCode');
    showToast(context, screenCode!);
  }

  Future<void> showLoad(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Center(
            child: LinearProgressIndicator(),
          ),
        );
      },
    );
  }
}
//login: ptcui

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
