bool connectionStatus = true;
Future check() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      connectionStatus = true;
    }
  } on SocketException catch (_) {
    connectionStatus = false;
  }
}

class _BackButtonState extends State<BackButton> {
  DateTime backbuttonpressedTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 0),
        child: AppBar(
          title: Text(""),
          backgroundColor: Colors.deepPurple,
        ),
      ),
      body: FutureBuilder(
          future: check(), // a previously-obtained Future or null
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (connectionStatus == true) {
              return WillPopScope(
                onWillPop: onWillPop,
                child: WebviewScaffold(
                  url: 'https://www.theonlineindia.co.in',
                  hidden: true,
                  initialChild: Container(
                    child: const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepPurple)),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text('No internet connection !!!',
                            style: TextStyle(
                              // your text
                              fontFamily: 'Aleo',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            )),
                      ),
                      /* RaisedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    color: Color(0xFF673AB7),
                    textColor: Colors.white,
                    child: Text('Refresh'),
                  ), */
                      // your button beneath text
                    ],
                  ));
            }
          }),
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //ifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 2);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double tap to exit the app",
          backgroundColor: Colors.deepPurple,
          textColor: Colors.white);
      return false;
    }
    exit(0);
    return true;
  }
}