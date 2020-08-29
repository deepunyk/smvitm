import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smvitm/screens/faculty_detail_screen.dart';
import 'package:smvitm/screens/select_category_screen.dart';
import 'package:smvitm/widgets/about.dart';
import 'package:smvitm/widgets/categories_widget.dart';
import 'package:smvitm/widgets/faculty_details.dart';
import 'package:smvitm/widgets/feed_widget.dart';
import 'package:smvitm/widgets/report_issue.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color _color;
  List _navHead = [
    'News Feed',
    'Categories',
    'Faculty Details',
    'Report an issue',
    'About'
  ];
  int _curIndex = 0;
  List<Widget> _widgetList = [
    FeedWidget(),
    CategoryWidget(),
    FacultyDetails(),
    ReportIssue(),
    About()
  ];

  Widget _getDrawerItems(
      String title, Function onTap, IconData icon, int code) {
    return Container(
      color: code == _curIndex ? _color.withOpacity(0.05) : Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
        leading: Icon(
          icon,
          color: code == _curIndex ? _color : Colors.black54,
        ),
      ),
    );
  }

  Widget _getDrawer(double height) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: height * 0.05),
              child: Image.asset(
                'assets/icons/logo_color.png',
                height: height * 0.08,
                width: height * 0.08,
                fit: BoxFit.contain,
              ),
            ),
            _getDrawerItems('${_navHead[0]}', () {
              setState(() {
                _curIndex = 0;
                Navigator.of(context).pop();
              });
            }, MdiIcons.newspaper, 0),
            _getDrawerItems('${_navHead[1]}', () {
              setState(() {
                _curIndex = 1;
                Navigator.of(context).pop();
              });
            }, MdiIcons.newspaperVariantMultiple, 1),
            _getDrawerItems('${_navHead[2]}', () {
              setState(() {
                _curIndex = 2;
                Navigator.of(context).pop();
              });
            }, MdiIcons.teach, 2),
            _getDrawerItems('${_navHead[3]}', () {
              setState(() {
                _curIndex = 3;
                Navigator.of(context).pop();
              });
            }, MdiIcons.alert, 3),
            _getDrawerItems('${_navHead[4]}', () {
              setState(() {
                _curIndex = 4;
                Navigator.of(context).pop();
              });
            }, MdiIcons.information, 4),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: _curIndex != 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, SelectCategoryScreen.routeName);
              },
              child: Icon(
                Icons.add,
                color: _color,
              ),
              backgroundColor: Colors.white,
            ),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "${_navHead[_curIndex]}",
          style: TextStyle(
              color: _color, letterSpacing: 0.2, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: _color),
        actions: [
          if (_curIndex == 2)
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: _color,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(FacultyDetailScreen.routeName);
                })
        ],
      ),
      drawer: _getDrawer(_mediaQuery.height),
      body: Container(height: double.infinity, child: _widgetList[_curIndex]),
    );
  }
}
