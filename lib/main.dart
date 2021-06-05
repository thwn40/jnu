import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Settings.dart';
import 'package:myapp/register.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:myapp/login.dart';
import 'package:myapp/search.dart';
import 'package:myapp/CustomerCenter.dart';
import 'package:myapp/Guide.dart';
import 'package:myapp/Notice.dart';
import 'package:myapp/Point.dart';
import 'package:myapp/Parking.dart';
import 'package:http/http.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: '네비게이션',
    home: LogIn(),
  ));
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          // backgroundImage: NetworkImage(
                          //     'http://www.bbk.ac.uk/mce/wp-content/uploads/2015/03/8327142885_9b447935ff.jpg'),
                          radius: 40.0,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.2, 0.0),
                        child: TextButton(
                            onPressed: () {
                              while (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              '로그인하세요',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            )),
                      ),
                    ],
                  ),
                ),
                height: 150),
            ListTile(
                title: Text(
                  '포인트',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Point();
                  }));
                }),
            ListTile(
                title: Text(
                  '공유주차장 관리',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Parking();
                  }));
                }),
            ListTile(
                title: Text(
                  '공지사항',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Notice();
                  }));
                }),
            ListTile(
                title: Text(
                  '서비스 이용안내',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Guide();
                  }));
                }),
            ListTile(
                title: Text(
                  '고객센터',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return CustomerCenter();
                  }));
                }),
            ListTile(
                title: Text(
                  '설정',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Settings();
                  }));
                }),
          ],
        ),
      ),
      // This is handled by the search bar itself.

      body: Stack(
        fit: StackFit.expand,
        children: [
          MyHomePage(),
          buildFloatingSearchBar(context),
        ],
      ),
    );
  }
}

Widget buildFloatingSearchBar(BuildContext context) {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  void _openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  return FloatingSearchBar(
    automaticallyImplyBackButton: false,
    hint: 'Search...',
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    key: _drawerKey,
    transition: CircularFloatingSearchBarTransition(),

    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Colors.accents.map((color) {
              return Container(height: 112, color: color);
            }).toList(),
          ),
        ),
      );
    },
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _drawerKey,
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://balmy-virtue-314416.web.app',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
