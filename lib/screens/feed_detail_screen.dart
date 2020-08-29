import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smvitm/screens/image_view_screen.dart';
import 'package:smvitm/screens/pdf_view_screen.dart';
import 'package:smvitm/screens/splash_screen.dart';
import 'package:smvitm/utility/feed_utility.dart';
import 'package:smvitm/widgets/loading.dart';

class FeedDetailScreen extends StatefulWidget {
  static const routeName = '/feed';

  @override
  _FeedDetailScreenState createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  Map<String, dynamic> _feedList;

  Color _color;
  double height = 0, width = 0;
  final box = GetStorage();
  FeedUtility _feedUtility = FeedUtility();
  bool isLoad = false;

  bool _checkFaculty() {
    if (box.hasData('id')) {
      if (_feedList['facultyId'] == box.read('id')) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  String _convertDate() {
    String time = _feedList['time'].toString();
    return DateFormat.d()
        .add_E()
        .add_jm()
        .format(DateTime.parse(time))
        .toString();
  }

  Widget _topDetail() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: _color,
            backgroundImage: NetworkImage(
              _feedList['facultyImg'],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _feedList['facultyName'].toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                _convertDate(),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getImg(String url) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ImageViewScreen.routeName, arguments: url);
      },
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget _midDetail() {
    return Hero(
      tag: _feedList['feedId'].toString(),
      child: SizedBox(
          height: 250.0,
          width: width,
          child: Carousel(
            images: _feedList['feedRes'].map((e) {
              return _getImg(e);
            }).toList(),
            dotSize: 4.0,
            dotSpacing: 15.0,
            dotColor: Theme.of(context).accentColor,
            indicatorBgPadding: 5.0,
            dotBgColor: Colors.transparent,
            borderRadius: false,
            autoplay: false,
          )),
    );
  }

  Widget _bottomDetail() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            _feedList['feedDescription'].toString(),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _getDoc(String docPath) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(PDFViewScreen.routeName, arguments: docPath);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shadowColor: _color,
        elevation: 2,
        child: Container(
          width: 75,
          height: 75,
          alignment: Alignment.center,
          child: Icon(
            MdiIcons.filePdfBox,
            color: _color,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _midPdfDetail() {
    return Container(
      height: 95,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return _getDoc(_feedList['feedRes'][index]);
          },
          itemCount: _feedList['feedRes'].length),
    );
  }

  @override
  Widget build(BuildContext context) {
    _feedList =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          _feedList['feedTitle'],
          style: TextStyle(
              color: _color, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: _color),
        actions: [
          if (_checkFaculty())
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                setState(() {
                  isLoad = true;
                });
                await _feedUtility.deleteFeed(_feedList['feedId']);
                setState(() {
                  isLoad = false;
                });
                Navigator.of(context).pushNamedAndRemoveUntil(
                    SplashScreen.routeName, (route) => false);
              },
            ),
        ],
      ),
      body: isLoad
          ? Loading()
          : Card(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  _topDetail(),
                  SizedBox(
                    height: 10,
                  ),
                  if (_feedList['feedType'] == 'Image') _midDetail(),
                  _bottomDetail(),
                  if (_feedList['feedType'] == 'Document') _midPdfDetail(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }
}
