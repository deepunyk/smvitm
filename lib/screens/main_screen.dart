import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/models/faculty.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/screens/faculty_detail_screen.dart';
import 'package:smvitm/screens/faculty_profile_screen.dart';
import 'package:smvitm/screens/login_screen.dart';
import 'package:smvitm/screens/select_category_screen.dart';
import 'package:smvitm/widgets/about.dart';
import 'package:smvitm/widgets/categories_widget.dart';
import 'package:smvitm/widgets/faculty_details.dart';
import 'package:smvitm/widgets/feed_widget.dart';
import 'package:smvitm/widgets/report_issue.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color _color;
  Faculties _faculties;
  List _navHead = [
    'News Feed',
    'Categories',
    'Faculty Details',
    'Report an issue',
    'About'
  ];
  List<Widget> _widgetList = [];
  int _curIndex = 0;

  switchTabs(int index) {
    setState(() {
      _curIndex = index;
    });
  }

  addScreens() {
    _widgetList = [
      FeedWidget(switchTabs),
      CategoryWidget(),
      FacultyDetails(),
      ReportIssue(),
      About(),
    ];
  }

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

  bool _checkFaculty() {
    final box = GetStorage();
    return box.hasData('id');
  }

  Widget _getDrawerHead(double height) {
    final box = GetStorage();
    Faculty faculty = _faculties.getOneFaculty(box.read('id'));
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'imgTag',
            child: CircleAvatar(
              radius: 30,
              backgroundColor: _color,
              backgroundImage: NetworkImage(
                faculty.photo,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                faculty.name,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                faculty.designation,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: 13),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getDrawer(double height) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              GestureDetector(
                onTap: _checkFaculty()
                    ? () {
                        Navigator.pushNamed(
                            context, FacultyProfileScreen.routeName);
                      }
                    : null,
                child: _checkFaculty()
                    ? _getDrawerHead(height)
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.05),
                        child: Image.asset(
                          'assets/icons/logo_color.png',
                          height: height * 0.08,
                          width: height * 0.08,
                          fit: BoxFit.contain,
                        ),
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
              _getDrawerItems('${_navHead[4]}', () async {
                const url = 'https://www.instagram.com/x_to_infinity/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
                setState(() {
                  Navigator.of(context).pop();
                });
              }, MdiIcons.information, 4),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Login to Post",
            style: TextStyle(fontWeight: FontWeight.w600, color: _color),
          ),
          content: new Text(
              "Only faculties are allowed to post in the newsfeed. To login as a faculty click below."),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Login",
                style: TextStyle(color: _color),
              ),
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addScreens();
  }

  Future<bool> _willPopCallback() async {
    if (_curIndex != 0) {
      setState(() {
        _curIndex = 0;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    _faculties = Provider.of<Faculties>(context);

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: _curIndex != 0
            ? null
            : FloatingActionButton(
                onPressed: _checkFaculty()
                    ? () {
                        Navigator.pushNamed(
                            context, SelectCategoryScreen.routeName);
                      }
                    : _showDialog,
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
      ),
    );
  }
}
