import 'package:carousel_slider/carousel_slider.dart';
import 'package:digitalsignange/UI/ImageScreen.dart';
import 'package:digitalsignange/MODELS/ContentModel.dart';
import 'package:digitalsignange/MODELS/MediaDetailModel.dart';
import 'package:digitalsignange/MODELS/ZoneModel.dart';
import 'package:digitalsignange/UI/PdfView.dart';
import 'package:digitalsignange/UI/VideoPLayer.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class SingleZoneView extends StatefulWidget {
  MediaDetails details;
  SingleZoneView({required this.details});

  @override
  State<SingleZoneView> createState() => _SingleZoneViewState();
}

class _SingleZoneViewState extends State<SingleZoneView> {
  List<Widget> widgetList = [];
  CarouselSliderController controller = CarouselSliderController();
  double factor = 0;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.details.contentsList.forEach((element) {
      widgetList.add(getWidget(element));
    });
    changeController();
    return Container(
      child: CarouselSlider(
          carouselController: controller,
          items: widgetList,
          options: CarouselOptions(
              height:
                  (MediaQuery.of(context).size.height * widget.details.height) /
                      100,
              aspectRatio: widget.details.width / widget.details.height,
              viewportFraction: 1)),
    );
    // return Container(
    //   color: Colors.red,
    // );
  }

  Widget getWidget(Contents contents) {
    if (contents.format == "jpeg") {
      String fullUrl = contents.url;
      return Container(
        width: (MediaQuery.of(context).size.width * widget.details.width) / 100,
        height:
            (MediaQuery.of(context).size.height * widget.details.height) / 100,
        child: ImageScreen(url: fullUrl),
      );
    } else if (contents.format == "mp4") {
      String fullUrl = contents.url;
      return VideoPlayer(url: fullUrl);
    } else if (contents.format == "pdf") {
      String fullUrl = contents.url;
      return CustomPdf(fullUrl);
    }
    return Center();
  }

  void changeController() {
    if (widget.details.contentsList.length - 1 < currentIndex) {
      currentIndex = 0;
    }
    Future.delayed(
        Duration(
            seconds:
                int.parse(widget.details.contentsList[currentIndex].duration)),
        () {
      controller.nextPage();
      currentIndex++;
      changeController();
    });
  }
}
