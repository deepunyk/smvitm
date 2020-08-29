import 'package:flutter/material.dart';
import 'package:smvitm/models/category.dart';
import 'package:smvitm/models/feed.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';

class Feeds with ChangeNotifier{

  List<Feed> _feeds = [];

  void addFeed(Feed _feed){
    _feeds.add(_feed);
  }

  List<Map<String,dynamic>> getFeed(FeedResources feedResources, Faculties faculties){
    List<Map<String,dynamic>> _feedList = [];
    _feeds.map((e){
      _feedList.add({
        'feedId':e.feedId,
        'feedDescription':e.feedDescription,
        'time':e.feedTime,
        'feedTitle':e.feedTitle,
        'feedType':e.feedType,
        'feedRes':feedResources.getFeedResource(e.feedId),
        'facultyName':faculties.getFacultyName(e.facultyId),
        'facultyId':e.facultyId,
        'facultyImg':  faculties.getFacultyImage(e.facultyId),
      });
    }).toList();
    return _feedList;
  }
}