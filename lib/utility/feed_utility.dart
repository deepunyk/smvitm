import 'package:http/http.dart' as http;
import 'package:smvitm/utility/url_utility.dart';

class FeedUtility {
  Future<void> deleteFeed(String id) async {
    final response =
        await http.post('${UrlUtility.mainUrl}deleteFeed.php', body: {
      'feed_id': id,
    });
    return;
  }
}
