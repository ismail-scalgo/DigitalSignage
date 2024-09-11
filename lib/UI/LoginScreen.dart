// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:digitalsignange/Costants.dart';
import 'package:digitalsignange/UI/LaunchingScreen.dart';
import 'package:digitalsignange/UI/RegisterScreen.dart';
import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [
                Color.fromARGB(255, 223, 124, 124),
                Color.fromARGB(255, 28, 91, 128)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ],
              Container(
                height: height / 1.5,
                width: width / 1.7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    tileMode: TileMode.mirror,
                    colors: [
                      Color.fromARGB(255, 212, 135, 135),
                      Color.fromARGB(255, 0, 69, 109)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  color: Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child:
                    //       Text("Enter the Screen Code to Launch the Signage Preview",
                    //           style: TextStyle(
                    //             fontSize: 17,
                    //             fontWeight: FontWeight.bold,
                    //           )),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                    //   child: TextField(
                    //     controller: screenCodeController,
                    //     decoration: InputDecoration(
                    //       labelText: "Screen Code",
                    //       errorText: screenCodeError,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 50, right: 50),
                      child: TextField(
                        style: TextStyle(
                            color: Color.fromARGB(255, 209, 209, 209)),
                        controller: screenCodeController,
                        decoration: InputDecoration(
                          labelText: 'Agent ID',
                          errorText: screenCodeError,
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 209, 209, 209)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 209, 209, 209)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 209, 209, 209)),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 40),
                    //   child: ElevatedButton(
                    //       onPressed: () {
                    //         validateInput();
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor: Colors.black,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(8.0),
                    //           ),
                    //           padding:
                    //               EdgeInsets.symmetric(horizontal: 70, vertical: 15)),
                    //       child: Text(
                    //         "Submit",
                    //         style: TextStyle(color: Colors.white),
                    //       )),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: InkWell(
                        child: Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              tileMode: TileMode.mirror,
                              colors: [
                                Color.fromARGB(255, 230, 163, 163),
                                Color.fromARGB(255, 6, 104, 160)
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
                          checkConnectivity();
                          validateInput(screenCodeController.text);
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: InkWell(
                    //     hoverColor: const Color.fromARGB(255, 224, 224, 224),
                    //     onTap: () {
                    //       registerClicked();
                    //     },
                    //     child: Text("Register",
                    //         style: TextStyle(
                    //           fontSize: 13,
                    //           fontWeight: FontWeight.bold,
                    //         )),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        hoverColor: const Color.fromARGB(255, 224, 224, 224),
                        onTap: () {
                          registerClicked();
                        },
                        child: Text("Register",
                            style: TextStyle(
                              color: Color.fromARGB(255, 209, 209, 209),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ),
                    BlocConsumer<RegisterblocBloc, RegisterblocState>(
                      // buildWhen: (previous, current) {
                      // },
                      listener: (context, state) {
                        if (state is LaunchScreen) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LaunchingScreen()),
                          );
                        }
                        if (state is DisplayRegistration) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        }
                        if (state is loginFailureState) {
                          print("failure state emittingggg");
                          showToast(context, state.message);
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
              ),
            ],
          ),
        ),
      )),
    );
  }

  void validateInput(String screenCode) async {
    if(await isOffline()) {
      showToast(context, "No Internet Connection");
      return;
    }
    setState(() {
      if (screenCodeController.text.trim().isEmpty) {
        screenCodeError = "Screen Code is required";
      } else {
        screenCodeError = null;
        loginBloc.add(LoginUser(screenCode: screenCode));
      }
    });
  }

  void showToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      backgroundColor: Color.fromARGB(255, 212, 135, 135),
      foregroundColor: Colors.white,
      type: ToastificationType.success,
      style: ToastificationStyle.simple,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  void registerClicked() async {
    if(await isOffline()) {
      showToast(context, "No Internet Connection");
      return;
    }
    loginBloc.add(ShowRegister());
  }
  
  void checkConnectivity() async {
  }
}
//login: ptcui