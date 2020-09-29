import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:smvitm/models/category.dart';
import 'package:smvitm/models/faculty.dart';
import 'package:smvitm/models/feed.dart';
import 'package:smvitm/models/feed_resource.dart';
import 'package:smvitm/providers/categories.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';
import 'package:smvitm/providers/feeds.dart';
import 'package:smvitm/utility/url_utility.dart';

class CollectData {
  Future<bool> allData(Categories categories, Faculties faculties, Feeds feeds,
      FeedResources feedResources) async {
    categories.deleteItem();
    faculties.deleteItem();
    feeds.deleteItem();
    feedResources.deleteItem();

    final response =
        await http.post('${UrlUtility.mainUrl}getAll.php', body: {});
    final userResponse = json.decode(response.body);
    final allData = userResponse['allData'];
    List facultyData = allData['faculty'];
    List categoryData = allData['category'];
    List feedData = allData['feed'];
    List feedResourceData = allData['feedResource'];
    List update = allData['update'];

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = await packageInfo.version;

    if (update[0]['version'].toString() != version) {
      return false;
    }

    facultyData.map((e) {
      faculties.addFaculty(Faculty(
        id: e['faculty_id'].toString(),
        branch: e['faculty_branch'].toString(),
        designation: e['faculty_designation'].toString(),
        email: e['faculty_email'].toString(),
        name: e['faculty_name'].toString(),
        phone: e['faculty_phone'].toString(),
        photo: e['faculty_photo'].toString(),
        password: e['password'].toString(),
      ));
    }).toList();
    categoryData.map((e) {
      categories.addCategory(
        Category(
          id: e['category_id'].toString(),
          image: e['category_image'].toString(),
          name: e['category_name'].toString(),
        ),
      );
    }).toList();

    feedData.map((e) {
      feeds.addFeed(
        Feed(
          categoryId: e['catergory_id'].toString(),
          facultyId: e['faculty_id'].toString(),
          feedDescription: e['feed_description'].toString(),
          feedId: e['feed_id'].toString(),
          feedTime: e['feed_time'].toString(),
          feedTitle: e['feed_title'].toString(),
          feedType: e['feed_type'].toString(),
        ),
      );
    }).toList();

    feedResourceData.map((e) {
      feedResources.addFeedResoucre(
        FeedResource(
            feedId: e['feed_id'], feedRes: e['feed_res'], frId: e['fr_id']),
      );
    }).toList();

    final box = GetStorage();
    if (box.hasData('selectedList')) {
      List _selectedList = box.read('selectedList');
      _selectedList.map((e) {
        categories.addSelectedCategory(e);
      }).toList();
    }
    return true;
  }
}
