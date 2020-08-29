import 'package:flutter/material.dart';
import 'package:smvitm/models/feed_resource.dart';

class FeedResources with ChangeNotifier {
  List<FeedResource> _feedResources = [];

  void addFeedResoucre(FeedResource _feedResource) {
    _feedResources.add(_feedResource);
  }

  List<String> getFeedResource(String id) {
    List<String> _feedResList = [];
    _feedResources.map((e) {
      if (e.feedId == id) {
        _feedResList.add(e.feedRes);
      }
    }).toList();
    return _feedResList;
  }

  deleteItem() {
    _feedResources.clear();
  }
}
