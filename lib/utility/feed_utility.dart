import 'package:http/http.dart' as http;

class FeedUtility {
  Future<void> deleteFeed(String id) async {
    final response = await http
        .post('http://smvitmapp.xtoinfinity.tech/php/deleteFeed.php', body: {
      'feed_id': id,
    });
    return;
  }
}
