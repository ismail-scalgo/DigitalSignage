import 'dart:async';

import 'package:player/Utils.dart';
import 'package:player/WebViewCache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  String url;
  AppWebView({required this.url, required super.key});

  @override
  State<AppWebView> createState() => _MywebviewState();
}

class _MywebviewState extends State<AppWebView> {
  late WebViewController controller;
  late WebViewController controller2;
  bool iscompleted = false;
  @override
  void initState() {
    DebugPrint("init called");
    DebugPrint(widget.url);
    // loadMedia();
    // loadWebPage(widget.url);

    super.initState();
  }

  Future loadMedia() async {
    var file = await DefaultCacheManager().getSingleFile(widget.url);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            DebugPrint(progress);
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            DebugPrint("page finished");
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadFile(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: WEBVIEWCACHE[widget.url]!);
    // return iscompleted
    //     ? WebViewWidget(controller: controller)
    //     : Center(
    //         child: Text(
    //           "DOWNLOAD PROGRESS",
    //           style: TextStyle(color: Colors.white, fontSize: 30),
    //         ),
    //       );
  }

  Future<void> loadWebPage(String url) async {
    final Completer<void> pageLoadCompleter = Completer<void>();

    controller2 = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            DebugPrint("Loading progress: $progress%");
          },
          onPageStarted: (String url) {
            DebugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            DebugPrint("Page finished loading: $url");
            if (!pageLoadCompleter.isCompleted) {
              pageLoadCompleter.complete();
            }
          },
          onHttpError: (HttpResponseError error) {
            DebugPrint("HTTP error: ${error.toString()}");
          },
          onWebResourceError: (WebResourceError error) {
            DebugPrint("Web resource error: ${error.description}");
            if (!pageLoadCompleter.isCompleted) {
              pageLoadCompleter.completeError(error);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    await pageLoadCompleter.future;
    postdownload(url);

    DebugPrint("Page load completed. Continue execution.");
  }

  Future postdownload(String url) async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            DebugPrint("Loading progress: $progress%");
          },
          onPageStarted: (String url) {
            DebugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            setState(() {
              iscompleted = true;
            });
          },
          onHttpError: (HttpResponseError error) {
            DebugPrint("HTTP error: ${error.toString()}");
          },
          onWebResourceError: (WebResourceError error) {
            DebugPrint("Web resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class AppWebView extends StatefulWidget {
//   String url;
//   AppWebView({required this.url, super.key});

//   @override
//   State<AppWebView> createState() => _AppWebViewState();
// }

// class _AppWebViewState extends State<AppWebView> {
//   @override
//   void initState() {
//     DebugPrint("WEB VIEW CALLEEEDDDDD");
//     controlldownload(widget.url);
//     //   preloadHtMlContents(widget.url);
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center();
//   }
// }

// Future controlldownload(String url) async {
//   DebugPrint("START DONLOADX");
//  // await preloadHtMlContents(url);
//   DebugPrint("DOWNLLOAD COMPLETE");
// }

// Future<void> preloadHtMlContents(String url) async {
//   final completer = Completer<void>();

//   WebViewController controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//           DebugPrint(progress);
//         },
//         onPageStarted: (String url) {},
//         onPageFinished: (String url) {
//           DebugPrint("page finished");
//           completer.complete();
//         },
//         onHttpError: (HttpResponseError error) {},
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse(url));

//   return await completer.future;
// }
