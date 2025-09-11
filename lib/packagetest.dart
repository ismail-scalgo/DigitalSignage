// PackageTest CODE
import 'package:fire_tv_listener/fire_tv_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PackageTest extends StatefulWidget {
  const PackageTest({Key? key}) : super(key: key);

  @override
  _PackageTestState createState() => _PackageTestState();
}

class _PackageTestState extends State<PackageTest> {
  final fn = FocusNode();

  String pressed = '- PRESS A BUTTON -';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fn.dispose();
  }

  void rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FireTVRemoteListener(
      onUp: () => pressed = 'UP',
      onDown: () => pressed = 'DOWN',
      onLeft: () => pressed = 'LEFT',
      onRight: () => pressed = 'RIGHT',
      onMenu: () => pressed = 'MENU',
      onSelect: () => pressed = 'SELECT',
      onFF: () => pressed = 'FF',
      onRew: () => pressed = 'REW',
      onPlayPause: () => pressed = 'PLAY/PAUSE',
      // onBack: () => back = true, // back sends android back key

      focusNode: fn,
      child: Scaffold(
        body: Center(child: Text(pressed, style: TextStyle(fontSize: 60))),
      ),
    );
  }
}
