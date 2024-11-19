// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdfx/pdfx.dart';

class CustomPdf extends StatefulWidget {
  String url;
  CustomPdf(this.url);

  @override
  State<CustomPdf> createState() => _CustomPdfState();
}

class _CustomPdfState extends State<CustomPdf> {
  late PdfController pdfPinchController;
  bool isLoading = true;
  late AnimationController ccontroller;
  int page = 1;

  bool isdisposed = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator()) // Show a loading indicator

            : PdfView(
                controller: pdfPinchController,
              ));
  }

  Future<void> load() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.url,
          headers: {'Cache-Control': 'max-age=3600'});

      // Initialize the PDF controller with the loaded file
      pdfPinchController = PdfController(
        document: PdfDocument.openData(file.readAsBytes()),
      );
      setState(() {
        isLoading = false;
      });
      animation();
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  void dispose() {
    isdisposed = true;
    pdfPinchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void animation() async {
    await Future.delayed(Duration(seconds: 3));
    //may be it is scheduled before dispose that is why it is checked before animate to another page
    if (!isdisposed) {
      pdfPinchController.animateToPage(page,
          duration: Duration(milliseconds: 1000), curve: Curves.slowMiddle);
      page++;
      animation();
    }
  }
}
