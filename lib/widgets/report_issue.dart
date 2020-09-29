import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smvitm/utility/url_utility.dart';
import 'package:smvitm/widgets/loading.dart';

class ReportIssue extends StatefulWidget {
  @override
  _ReportIssueState createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  Color _color;
  double height = 0, width = 0;
  bool isLoad = false;
  String issue = "";

  _showSnackBar(BuildContext ctx, String text) {
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          "$text",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  _reportIssue(BuildContext ctx) async {
    if (issue.length < 6) {
      _showSnackBar(ctx, 'Please enter your issue in detail');
    } else {
      setState(() {
        isLoad = true;
      });
      final response =
          await http.post('${UrlUtility.mainUrl}addIssue.php', body: {
        'iss': issue,
      });
      print(response.body);
      if (response.body == 'yes') {
        _showSnackBar(ctx, 'Your issue has been reported.');
      } else {
        _showSnackBar(ctx, 'Oops.. Something went wrong');
      }
      setState(() {
        isLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return LayoutBuilder(
      builder: (ctx, constraints) => Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            left: _mediaQuery.width * 0.1,
            bottom: _mediaQuery.height * 0.1,
            right: _mediaQuery.width * 0.1),
        child: isLoad
            ? Loading()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Image.asset('assets/images/report.png',
                        width: height * 0.34),
                    const SizedBox(height: 20.0),
                    Text(
                      "Lost somewhere?",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Write your issue in detail so that it will be easier for us to fix it.",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: _mediaQuery.height * 0.05,
                    ),
                    Card(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: _color)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          onChanged: (val) {
                            issue = val;
                          },
                          onSubmitted: (val) {
                            _reportIssue(ctx);
                          },
                          decoration: InputDecoration.collapsed(
                              hintText: "Enter your issue here"),
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _mediaQuery.height * 0.05,
                    ),
                    Container(
                      width: _mediaQuery.width * 0.5,
                      child: RaisedButton(
                        onPressed: () {
                          _reportIssue(ctx);
                        },
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: _color,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
