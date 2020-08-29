import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';
import 'package:smvitm/providers/feeds.dart';
import 'package:smvitm/widgets/feed_card.dart';

class FeedWidget extends StatefulWidget {
  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {

  Feeds _feeds;
  Faculties _faculties;
  FeedResources _feedResources;
  Color _color;

  @override
  Widget build(BuildContext context) {

    _feeds = Provider.of<Feeds>(context);
    _feedResources = Provider.of<FeedResources>(context);
    _faculties = Provider.of<Faculties>(context);
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    
    return Container(
      child: ListView(
        children: _feeds.getFeed(_feedResources, _faculties).map((e){
          return FeedCard(e);
        }).toList(),
      ),
    );
  }
}
