import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HtmlApps extends StatefulWidget {
  String htmlUrl;
  HtmlApps({required this.htmlUrl, required super.key});

  @override
  State<HtmlApps> createState() => _HtmlAppsState();
}

class _HtmlAppsState extends State<HtmlApps> {
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    _webViewController!.takeScreenshot();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InAppWebView(
      //  initialData: InAppWebViewInitialData(data: htmlContent),
      initialUrlRequest: URLRequest(url: WebUri("https://www.scalgo.net/")),
    ));
  }
}
