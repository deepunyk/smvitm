import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/providers/categories.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';
import 'package:smvitm/providers/feeds.dart';
import 'package:smvitm/screens/main_screen.dart';
import 'package:smvitm/utility/collect_data.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  final bool loading;

  SplashScreen({this.loading = true});

  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CollectData _collectData = CollectData();
  bool code = false;
  Categories _categories;
  Feeds _feeds;
  FeedResources _feedResources;
  Faculties _faculties;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("No internet connection"),
          content:
              new Text("Please check your internet connection and try again"),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Okay",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _checkInternet();
              },
            ),
          ],
        );
      },
    );
  }

  void _newUpdate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("New update found"),
          content: new Text("Please go to playstore and update the app"),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Update",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () async {
                const url =
                    'https://play.google.com/store/apps/details?id=com.xti.smvitm&hl=en_IN';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      _initialize();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _initialize();
    } else {
      _showDialog();
    }
  }

  _initialize() async {
    if (await _collectData.allData(
        _categories, _faculties, _feeds, _feedResources)) {
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    } else {
      _newUpdate();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('all');
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    _feeds = Provider.of<Feeds>(context);
    _categories = Provider.of<Categories>(context);
    _faculties = Provider.of<Faculties>(context);
    _feedResources = Provider.of<FeedResources>(context);

    if (!code) {
      code = !code;
      _checkInternet();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/icons/logo_color.png',
                height: _mediaQuery.width * 0.2,
                width: _mediaQuery.width * 0.2,
                fit: BoxFit.contain,
              )),
          widget.loading
              ? Positioned(
                  bottom: _mediaQuery.height * 0.08,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitChasingDots(
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Please wait"),
                    ],
                  ),
                )
              : Positioned(
                  bottom: _mediaQuery.height * 0.08,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        "Developed By",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "X to Infinity",
                        style: TextStyle(fontSize: 16, fontFamily: 'Vampire'),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
