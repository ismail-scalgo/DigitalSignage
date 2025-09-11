// import 'package:digitalsignange/BLOC/RegisterBloc/bloc/registerbloc_bloc.dart';
// import 'package:digitalsignange/Costants.dart';
// import 'package:digitalsignange/MODELS/RequestModel.dart';
// import 'package:digitalsignange/UI/LaunchingScreen.dart';
// import 'package:digitalsignange/UI/NoInternetScreen.dart';

// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:toastification/toastification.dart';

// class ScreenCodeScreen extends StatefulWidget {
//   const ScreenCodeScreen({super.key});

//   @override
//   State<ScreenCodeScreen> createState() => _ScreenCodeScreenState();
// }

// class _ScreenCodeScreenState extends State<ScreenCodeScreen> {
//   late RegisterblocBloc registerBloc;
//   late String platform;
//   late RequestModel request;

//   @override
//   void initState() {
//     super.initState();
//     registerBloc = BlocProvider.of<RegisterblocBloc>(context);
//     // checkConnectivity();
//     checkScreenCode();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//           child: BlocConsumer<RegisterblocBloc, RegisterblocState>(
//         listener: (context, state) {
//           // TODO: implement listener
//           if (state is LaunchScreen) {
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         LaunchingScreen(screenCode: state.code)),
//                 (route) => false);
//           }
//         },
//         builder: (context, state) {
//           if (state is DisplayNewScreenCode) {
//             saveScreenCode(state.screenCode);
//             return Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   // transform: GradientRotation(0.3),
//                   tileMode: TileMode.mirror,
//                   colors: [
//                     Color.fromARGB(255, 43, 2, 109),
//                     Color.fromARGB(255, 0, 0, 0),
//                     Color.fromARGB(255, 0, 0, 0),
//                     Color.fromARGB(255, 0, 0, 0),
//                     Color.fromARGB(255, 0, 0, 0),
//                     Color.fromARGB(255, 0, 0, 0),
//                     Color.fromARGB(255, 0, 0, 0),
//                     Color.fromARGB(255, 43, 2, 109),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               height: height,
//               width: width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: height / 15,
//                   ),
//                   Container(
//                     // color: Colors.white,
//                     height: height / 1.2,
//                     width: width / 1.2,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Pair device",
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 190, 190, 190),
//                               fontSize: 25,
//                               // fontSize: width / 45,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 40,
//                         ),
//                         Text(
//                           "1,  Login to your Digital Signage account at www.web-sgdsg.com",
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 190, 190, 190),
//                               fontSize: 20,
//                               // fontSize: width / 50,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 40,
//                         ),
//                         Text(
//                           "2,  Select New Screen and enter this code in the popup",
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 190, 190, 190),
//                               fontSize: 20,
//                               // fontSize: width / 50,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 50,
//                         ),
//                         Text(
//                           state.screenCode,
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 190, 190, 190),
//                               fontSize: 50,
//                               // fontSize: width / 20,
//                               fontWeight: FontWeight.bold),
//                         ),

//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (state is OfflineState) {
//             return NoInternetScreen();
//           }
//           return Container(
//             color: Color.fromARGB(255, 0, 0, 0),
//             width: width,
//             height: height,
//             child: LoadingWidget(height, width),
//           );
//         },
//       )),
//     );
//   }

//   void checkScreenCode() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     // prefs.remove('NewScreenCode');
//     // prefs.remove('isRegistered');

//     String? screenCode = prefs.getString('NewScreenCode');
//     bool? isRegistered = prefs.getBool('isRegistered');
//     if (isRegistered == null) {
//       isRegistered = false;
//     }
//     DebugPrint("code = $screenCode");
//     DebugPrint("register = $isRegistered");
//        await checkConnectivity();
//     if (screenCode == null) {
//       DebugPrint("null code");

//       requestScreenCode();
//     } else if (!isRegistered) {

//       registerBloc.add(DisplayScreenCode(screenCode: screenCode));
//     } else {
//       DebugPrint("got it");
//       registerBloc.add(LaunchSignage(screenCode: screenCode));
//     }
//   }

//   void saveScreenCode(String screenCode) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('NewScreenCode', screenCode);
//     await prefs.setBool('isRegistered', false);
//   }

//   void requestScreenCode() async {
//     request = RequestModel(
//         width: MediaQuery.of(context).size.width.toInt().toString(),
//         height: MediaQuery.of(context).size.height.toInt().toString());
//     DebugPrint("adding event");
//     registerBloc.add(GetScreenCode(request: request));
//   }

//  Future checkConnectivity() async {
//     if (await isOffline()) {
//       DebugPrint("adding offline event");
//       registerBloc.add(OfflineEvent());
//       showToast(context, "No Internet Connection");
//     }
//   }

//   Widget LoadingWidget(double height, double width) {
//     return Center(
//         child: Container(
//             width: width / 10,
//             height: width / 10,
//             child: Lottie.asset('assets/loading3.json')
//             )
//           );
//   }

//   void showToast(BuildContext context, String message) {
//     toastification.show(
//       context: context,
//       backgroundColor: Color.fromARGB(255, 0, 0, 0),
//       foregroundColor: Color.fromARGB(255, 253, 253, 253),
//       type: ToastificationType.success,
//       style: ToastificationStyle.simple,
//       title: Text(message),
//       alignment: Alignment.topRight,
//       autoCloseDuration: const Duration(seconds: 2),
//     );
//   }
// }
