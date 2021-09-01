import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repkaba/green_page.dart';
import 'package:repkaba/red_page.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

String webLink = "https://reprezentacija.ba/";
late String deviceToken;
late bool connResult;

var connectivityResult = await(Connectivity().checkConnectivity());

await(Future<ConnectivityResult> checkConnectivity) {}

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  connResult = await checkInternetConnection();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(
        title: 'Flutter demo home page',
      ),
      routes: {"red": (_) => RedPage(), "green": (_) => GreenPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController controller;

  late Widget content = MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: webLink,
            onWebViewCreated: (WebViewController webViewController) {
              controller = webViewController;
            }),
      ),
    ),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        deviceToken = token!;
        // print(deviceToken);
        // storeToken(3);
      });

      print('-----------------main--------------------------------------');
      print(deviceToken);
      print('------------------main-----------------------------------------');
      storeToken(deviceToken);
    });
    //gives message on which user taps, open app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message);
        // final newLink = message.data['link'];
        webLink = message.data['link'];
      }
    });

    //app working in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        // print(message.notification!.body);
        // print(message.notification!.title);
      }
    });

    //when the app is in background but opened and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.notification!.body);
      final newLink = message.data['link'];
      // Navigator.of(context).pop(GreenPage(newLink));
      setState(() {
        controller.loadUrl(newLink);
      });
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    var res = await checkInternetConnection();
    print(res);
    setState(() {
      // _connectionStatus = result;
      if(res == true){
        content = MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: webLink,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                  }),
            ),
          ),
        );
      }
      else{
        content =  MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.blue,
            body: SafeArea(
                child: Center(
                  child: Text(
                    'Nemate pristup internetu. Molimo provjerite vašu konekciju!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                )),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (connResult == false) {
      print('no internet');
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.blue,
          body: SafeArea(
              child: Center(
                child: Text(
                  'Nemate pristup internetu. Molimo provjerite vašu konekciju!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              )),
        ),
      );
      return content;
    } else {
      print('there is internet');
      content =MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: webLink,
                onWebViewCreated: (WebViewController webViewController) {
                  controller = webViewController;
                }),
          ),
        ),
      );
      return content;
    }
  }
}

Future storeToken(token) async {
  http.Response response = await http.post(
    Uri.parse('http://api.europlac-nekretnine.com/product/create.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{'token': token}),
  );
}

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return true;
  } on SocketException catch (_) {
    return false;
  }
}
