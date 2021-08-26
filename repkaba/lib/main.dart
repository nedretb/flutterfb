import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:repkaba/green_page.dart';
import 'package:repkaba/red_page.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;


String webLink = "https://reprezentacija.ba/";

Future<void> backgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHomePage(title: 'Flutter demo home page',),
      routes: {
        "red": (_) => RedPage(),
        "green": (_) => GreenPage()
      },
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
  late String deviceToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getToken().then((token) {
      print('token');
      print(token);
      setState(() {
        deviceToken = token!;
      });
    });
    //gives message on which user taps, open app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        print(message);
        // final newLink = message.data['link'];
        webLink = message.data['link'];
      }
    });

    //app working in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
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

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child:  WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: webLink,
                onWebViewCreated: (WebViewController webViewController) {
                  controller = webViewController;
              }
            ),
        ),
      ),
    );
  }
}

Future storeToken(token) async {
  http.Response response = await http.post(
    Uri.parse('https://alkaris.com/api/login-system/check-for-user-data'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-CSRF-TOKEN': ''
    },
    body: jsonEncode(<String, String>{
      'token': '1'
    }),
  );
}

void printToken(token){
  print(token);
}