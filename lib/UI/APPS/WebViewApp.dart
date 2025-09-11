import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webviewapp extends StatefulWidget {
  String url;
  Webviewapp({required this.url});

  @override
  State<Webviewapp> createState() => _WebviewappState();
}

class _WebviewappState extends State<Webviewapp> {
  late WebViewController controller;

  bool isloading = true;

  @override
  void initState() {
    loaddata();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }

  void loaddata() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
}
