// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:toast/toast.dart';

// void main() => runApp(MaterialApp(home: WebViewExample()));

// const String kNavigationExamplePage = '''
// <!DOCTYPE html><html>
// <head><title>Navigation Delegate Example</title></head>
// <body>
// <p>
// The navigation delegate is set to block navigation to the youtube website.
// </p>
// <ul>
// <ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
// <ul><a href="https://www.facebook.com/">https://www.google.com/</a></ul>
// </ul>
// </body>
// </html>
// ''';

// class WebViewExample extends StatefulWidget {
//   @override
//   _WebViewExampleState createState() => _WebViewExampleState();
// }

// class _WebViewExampleState extends State<WebViewExample> {
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   TextEditingController tedGetUrl;
//   String text;
//   String googleSearch = "https://google.com/search?q=";

//   void _getUrlText() {
//     setState(() {
//         text = tedGetUrl.text.trim();
//       googleSearch = "https://google.com/search?q=$text";
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//     tedGetUrl = TextEditingController();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 height: 40,
//                 width: MediaQuery.of(context).size.width * 0.30,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     onSubmitted: (String s) {},
//                     // onEditingComplete: (){
//                     //   Toast.show("$tedGetUrl", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

//                     // },
//                     controller: tedGetUrl,

//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.only(left: 10),
//                       hintText: "Search",
//                       enabledBorder: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                         borderSide: const BorderSide(
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.search_rounded,
//                     color: Colors.white,
//                   ),
//                   onPressed:
//                   (){
//                     text = tedGetUrl.text.trim();
//                     Toast.show("$text", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
//                  //   _getUrlText;

//                   },
//                 ),
//               )
//             ],
//           ),
//           actions: <Widget>[
//             NavigationControls(_controller.future),
//             SampleMenu(_controller.future),
//           ],
//         ),
//         body: Builder(builder: (BuildContext context) {

//           return WebView(
//             initialUrl: '$googleSearch',
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller.complete(webViewController);
//             },
//             javascriptChannels: <JavascriptChannel>{
//               _toasterJavascriptChannel(context),
//             },
//             navigationDelegate: (NavigationRequest request) {
//               if (request.url.startsWith('https://www.youtube.com/')) {
//                 print('blocking navigation to $request}');
//                 return NavigationDecision.prevent;
//               }
//               print('allowing navigation to $request');
//               return NavigationDecision.navigate;
//             },
//             onPageStarted: (String url) {
//               print('Page started loading: $url');
//             },
//             onPageFinished: (String url) {
//               print('Page finished loading: $url');
//             },
//             gestureNavigationEnabled: true,
//           );
//         }),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _getUrlText,
//         )

//         //favoriteButton(),
//         );
//   }

//   JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//     return JavascriptChannel(
//         name: 'Toaster',
//         onMessageReceived: (JavascriptMessage message) {
//           // ignore: deprecated_member_use
//           Scaffold.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         });
//   }

//   Widget favoriteButton() {
//     return FutureBuilder<WebViewController>(
//         future: _controller.future,
//         builder: (BuildContext context,
//             AsyncSnapshot<WebViewController> controller) {
//           if (controller.hasData) {
//             return FloatingActionButton(
//               onPressed: () async {
//                 final String url = (await controller.data.currentUrl());
//                 // ignore: deprecated_member_use
//                 Scaffold.of(context).showSnackBar(
//                   SnackBar(content: Text('Favorited $url')),
//                 );
//               },
//               child: const Icon(Icons.favorite),
//             );
//           }
//           return Container();
//         });
//   }
// }

// enum MenuOptions {
//   showUserAgent,
//   listCookies,
//   clearCookies,
//   addToCache,
//   listCache,
//   clearCache,
//   navigationDelegate,
// }

// class SampleMenu extends StatelessWidget {
//   SampleMenu(this.controller);

//   final Future<WebViewController> controller;
//   final CookieManager cookieManager = CookieManager();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: controller,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//         return PopupMenuButton<MenuOptions>(
//           onSelected: (MenuOptions value) {
//             switch (value) {
//               case MenuOptions.showUserAgent:
//                 _onShowUserAgent(controller.data, context);
//                 break;
//               case MenuOptions.listCookies:
//                 _onListCookies(controller.data, context);
//                 break;
//               case MenuOptions.clearCookies:
//                 _onClearCookies(context);
//                 break;
//               case MenuOptions.addToCache:
//                 _onAddToCache(controller.data, context);
//                 break;
//               case MenuOptions.listCache:
//                 _onListCache(controller.data, context);
//                 break;
//               case MenuOptions.clearCache:
//                 _onClearCache(controller.data, context);
//                 break;
//               case MenuOptions.navigationDelegate:
//                 _onNavigationDelegateExample(controller.data, context);
//                 break;
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//             PopupMenuItem<MenuOptions>(
//               value: MenuOptions.showUserAgent,
//               child: const Text('Show user agent'),
//               enabled: controller.hasData,
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCookies,
//               child: Text('List cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCookies,
//               child: Text('Clear cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.addToCache,
//               child: Text('Add to cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCache,
//               child: Text('List cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCache,
//               child: Text('Clear cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.navigationDelegate,
//               child: Text('Navigation Delegate example'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _onShowUserAgent(
//       WebViewController controller, BuildContext context) async {
//     // Send a message with the user agent string to the Toaster JavaScript channel we registered
//     // with the WebView.
//     await controller.evaluateJavascript(
//         'Toaster.postMessage("User Agent: " + navigator.userAgent);');
//   }

//   void _onListCookies(
//       WebViewController controller, BuildContext context) async {
//     final String cookies =
//         await controller.evaluateJavascript('document.cookie');
//     // ignore: deprecated_member_use
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const Text('Cookies:'),
//           _getCookieList(cookies),
//         ],
//       ),
//     ));
//   }

//   void _onAddToCache(WebViewController controller, BuildContext context) async {
//     await controller.evaluateJavascript(
//         'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
//     // ignore: deprecated_member_use
//     Scaffold.of(context).showSnackBar(const SnackBar(
//       content: Text('Added a test entry to cache.'),
//     ));
//   }

//   void _onListCache(WebViewController controller, BuildContext context) async {
//     await controller.evaluateJavascript('caches.keys()'
//         '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
//         '.then((caches) => Toaster.postMessage(caches))');
//   }

//   void _onClearCache(WebViewController controller, BuildContext context) async {
//     await controller.clearCache();
//     // ignore: deprecated_member_use
//     Scaffold.of(context).showSnackBar(const SnackBar(
//       content: Text("Cache cleared."),
//     ));
//   }

//   void _onClearCookies(BuildContext context) async {
//     final bool hadCookies = await cookieManager.clearCookies();
//     String message = 'There were cookies. Now, they are gone!';
//     if (!hadCookies) {
//       message = 'There are no cookies.';
//     }
//     // ignore: deprecated_member_use
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }

//   void _onNavigationDelegateExample(
//       WebViewController controller, BuildContext context) async {
//     final String contentBase64 =
//         base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
//     await controller.loadUrl('data:text/html;base64,$contentBase64');
//   }

//   Widget _getCookieList(String cookies) {
//     if (cookies == null || cookies == '""') {
//       return Container();
//     }
//     final List<String> cookieList = cookies.split(';');
//     final Iterable<Text> cookieWidgets =
//         cookieList.map((String cookie) => Text(cookie));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: cookieWidgets.toList(),
//     );
//   }
// }

// class NavigationControls extends StatelessWidget {
//   const NavigationControls(this._webViewControllerFuture)
//       : assert(_webViewControllerFuture != null);

//   final Future<WebViewController> _webViewControllerFuture;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewController controller = snapshot.data;
//         return Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                       if (await controller.canGoBack()) {
//                         await controller.goBack();
//                       } else {
//                         // ignore: deprecated_member_use
//                         Scaffold.of(context).showSnackBar(
//                           const SnackBar(content: Text("No back history item")),
//                         );
//                         return;
//                       }
//                     },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                       if (await controller.canGoForward()) {
//                         await controller.goForward();
//                       } else {
//                         // ignore: deprecated_member_use
//                         Scaffold.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("No forward history item")),
//                         );
//                         return;
//                       }
//                     },
//             ),
//             IconButton(
//               icon: const Icon(Icons.replay),
//               onPressed: !webViewReady
//                   ? null
//                   : () {
//                       controller.reload();
//                     },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//......................................................................................

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(new MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   InAppWebViewController webView;
//   String url = "";
//   double progress = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('InAppWebView Example'),
//         ),
//         body: Container(
//             child: Column(children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(20.0),
//             child: Text(
//                 "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
//           ),
//           Container(
//               padding: EdgeInsets.all(10.0),
//               child: progress < 1.0
//                   ? LinearProgressIndicator(value: progress)
//                   : Container()),
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(10.0),
//               decoration:
//                   BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//               child: InAppWebView(
//                 initialUrl: "https://google.com/",
//                 initialHeaders: {},
//                 initialOptions: InAppWebViewGroupOptions(
//                     crossPlatform: InAppWebViewOptions(
//                   debuggingEnabled: true,
//                 )),
//                 onWebViewCreated: (InAppWebViewController controller) {
//                   webView = controller;
//                 },
//                 onLoadStart: (InAppWebViewController controller, String url) {
//                   setState(() {
//                     this.url = url;
//                   });
//                 },
//                 onLoadStop:
//                     (InAppWebViewController controller, String url) async {
//                   setState(() {
//                     this.url = url;
//                   });
//                 },
//                 onProgressChanged:
//                     (InAppWebViewController controller, int progress) {
//                   setState(() {
//                     this.progress = progress / 100;
//                   });
//                 },
//               ),
//             ),
//           ),
//           ButtonBar(
//             alignment: MainAxisAlignment.center,
//             children: <Widget>[
//               RaisedButton(
//                 child: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   if (webView != null) {
//                     webView.goBack();
//                   }
//                 },
//               ),
//               RaisedButton(
//                 child: Icon(Icons.arrow_forward),
//                 onPressed: () {
//                   if (webView != null) {
//                     webView.goForward();
//                   }
//                 },
//               ),
//               RaisedButton(
//                 child: Icon(Icons.refresh),
//                 onPressed: () {
//                   if (webView != null) {
//                     webView.reload();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ])),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:toast/toast.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = '';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const MyHomePage(title: 'Flutter WebView Demo'),
        '/widget': (_) {
          return WebviewScaffold(
            url: selectedUrl,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            appBar: AppBar(
              title: const Text('Widget WebView'),
            ),
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      flutterWebViewPlugin.goBack();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      flutterWebViewPlugin.goForward();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.autorenew),
                    onPressed: () {
                      flutterWebViewPlugin.reload();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String _selectedSite = "Google";

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      String txt = _urlCtrl.text.trim();
      String finalUrl = 'https://google.com/search?q=$txt';

      if (_selectedSite == 'Google') {
        finalUrl = 'https://google.com/search?q=$txt';
      } 
      else if (_selectedSite == 'Bing') {
        finalUrl = 'https://bing.com/search?q=$txt';
      }
      else if (_selectedSite == 'AOL') {
        finalUrl = 'https://search.aol.com/aol/search?q=$txt';
      }
      else if (_selectedSite == 'Youtube') {
        finalUrl = 'https://youtube.com/results?search_query=$txt';
      }
      else if (_selectedSite == 'Yahoo') {
        finalUrl = 'https://search.yahoo.com/search?p=$txt';
      }
      selectedUrl = finalUrl;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedSite,
                    items: <String>['Google','Bing', 'AOL','Yahoo','Youtube', ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _selectedSite = value;
                        Toast.show("$_selectedSite", context,
                            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      });
                    },
                  ),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.53,
                    child: TextField(controller: _urlCtrl),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search_outlined,
                      color: Colors.black,
                    ),
                    tooltip: 'Increase volume by 10',
                    onPressed: () {
                       Navigator.of(context).pushNamed('/widget');
                     // setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedSite,
                    items: <String>['Google','Bing', 'AOL','Yahoo','Youtube', ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _selectedSite = value;
                        Toast.show("$_selectedSite", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      });
                    },
                  ),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: TextField(controller: _urlCtrl),
                  ),
                ],
              ),
            ),
            // RaisedButton(
            //   onPressed: () {
            //     flutterWebViewPlugin.launch(
            //       selectedUrl,
            //       rect: Rect.fromLTWH(MediaQuery.of(context).size.width, 300.0,
            //           MediaQuery.of(context).size.height, 300.0),
            //       userAgent: kAndroidUserAgent,
            //       invalidUrlRegex:
            //           r'^(https).+(twitter)', // prevent redirecting to twitter when user click on its icon in flutter website
            //     );
            //   },
            //   child: const Text('Open Webview (rect)'),
            // ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/widget');
              },
              child: const Text('Open widget webview'),
            ),
          ],
        ),
      ),
    );
  }
}
