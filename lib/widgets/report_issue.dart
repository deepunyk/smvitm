import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReportIssue extends StatefulWidget {
  @override
  _ReportIssueState createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  Color _color;
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          left: _mediaQuery.width * 0.1,
          bottom: _mediaQuery.height * 0.1,
          right: _mediaQuery.width * 0.1),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          Lottie.asset('assets/anim/lost.json', width: height * 0.25),
          Text(
            "Lost somewhere?",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Write your issue in detail so that it will be easier for us to fix it.",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
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
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: TextField(
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
              onPressed: () {},
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
    );
  }
}
