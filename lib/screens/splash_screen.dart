import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/providers/categories.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';
import 'package:smvitm/providers/feeds.dart';
import 'package:smvitm/screens/main_screen.dart';
import 'package:smvitm/utility/collect_data.dart';

class SplashScreen extends StatefulWidget {
  
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
  
  
  _initialize()async{
    await _collectData.allData(_categories, _faculties, _feeds, _feedResources);
    Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {

    final _mediaQuery = MediaQuery.of(context).size;
    _feeds = Provider.of<Feeds>(context);
    _categories = Provider.of<Categories>(context);
    _faculties = Provider.of<Faculties>(context);
    _feedResources = Provider.of<FeedResources>(context);

    if(!code){
      code = !code;
      _initialize();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(alignment: Alignment.center,child: Image.asset('assets/icons/logo_color.png',height: _mediaQuery.width*0.2,width: _mediaQuery.width*0.2,fit: BoxFit.contain,)),
          Positioned(
            bottom: _mediaQuery.height*0.08,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text("Developed By", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,),),
                Text("X to Infinity", style: TextStyle(fontSize: 16,fontFamily: 'Vampire'),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
