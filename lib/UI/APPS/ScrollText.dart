import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class ScrollText extends StatefulWidget {

  String text;
  String text_color;
  String background_color;
  String velocity;
  String direction;




  


   ScrollText({required this.text,required this.text_color,required this.background_color,required this.velocity,required this.direction});

  @override
  State<ScrollText> createState() => _ScrollTextState();
}

class _ScrollTextState extends State<ScrollText> {

  String text='';
  int text_color=0;
  int background_color=0;
  double velocity=0;
  TextDirection direction=TextDirection.ltr;
  
  @override
  void initState() {

    text=widget.text;
    text_color=int.parse("0x"+widget.text_color.replaceAll("#", "")+"ff");
    background_color=int.parse("0x"+widget.background_color.replaceAll("#", "")+"ff");
    velocity=double.parse(widget.velocity);

    direction=widget.direction=="RIGHT_TO_LEFT" ? TextDirection.ltr : TextDirection.rtl;
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(
      body: Center(
        child: Container(
          color: Color(background_color),
          child: TextScroll(
          text,
          mode: TextScrollMode.endless,
          velocity: Velocity(pixelsPerSecond: Offset(150, 0)),
          delayBefore: Duration(milliseconds: 2000),
          numberOfReps: 500,
          pauseBetween: Duration(milliseconds: 5000),
          style: TextStyle(color: Color(text_color),fontSize: 20),
          textAlign: TextAlign.right,
          selectable: true,
          textDirection: direction,
          ),
        )
      ),
    );
  }
}