import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/providers/categories.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';
import 'package:smvitm/providers/feeds.dart';
import 'package:smvitm/screens/splash_screen.dart';
import 'package:smvitm/widgets/feed_card.dart';

class FeedWidget extends StatefulWidget {
  final Function switchTabs;

  FeedWidget(this.switchTabs);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  Feeds _feeds;
  Faculties _faculties;
  FeedResources _feedResources;
  Categories _categories;
  Color _color;

  @override
  Widget build(BuildContext context) {
    _feeds = Provider.of<Feeds>(context);
    _feedResources = Provider.of<FeedResources>(context);
    _faculties = Provider.of<Faculties>(context);
    _color = Theme.of(context).primaryColor;
    _categories = Provider.of<Categories>(context);
    final _mediaQuery = MediaQuery.of(context).size;

    return _categories.getSelectedList().length == 0
        ? Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty.png',
                  width: _mediaQuery.width * 0.6,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "No categories subscribed",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    widget.switchTabs(1);
                  },
                  child: Text(
                    "Add Category",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: _color,
                )
              ],
            ),
          )
        : _feeds.getFeed(_feedResources, _faculties, _categories).length == 0
            ? Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty.png',
                      width: _mediaQuery.width * 0.6,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No news found",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    )
                  ],
                ),
              )
            : Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SplashScreen.routeName, (route) => false);
                  },
                  child: ListView(
                    children: _feeds
                        .getFeed(_feedResources, _faculties, _categories)
                        .map((e) {
                      return FeedCard(e);
                    }).toList(),
                  ),
                ),
              );
  }
}
