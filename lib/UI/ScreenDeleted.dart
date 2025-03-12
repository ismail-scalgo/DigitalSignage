import 'package:digitalsignange/UI/ScreenCodeScreen.dart';
import 'package:display_metrics/display_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lottie/lottie.dart';

class ScreenDeletedScreen extends StatefulWidget {
  const ScreenDeletedScreen({super.key});

  @override
  State<ScreenDeletedScreen> createState() => _ScreenDeletedScreenState();
}

class _ScreenDeletedScreenState extends State<ScreenDeletedScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 4), () async {
      await DefaultCacheManager().emptyCache();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PreScreenCodeScreen()),
          (route) => false);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "SCREEN DELETED",
                style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
              ),
            ),
          Lottie.asset('assets/deletedscreen.json',fit: BoxFit.cover,height: 200),

           Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Cache cleaning...",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),)
        
        
        
        
          ],
        ),
      ),
    );
  }
}
