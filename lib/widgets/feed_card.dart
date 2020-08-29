import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smvitm/screens/feed_detail_screen.dart';
import 'package:smvitm/screens/pdf_view_screen.dart';

class FeedCard extends StatefulWidget {
  final Map<String, dynamic> feedDetail;
  FeedCard(this.feedDetail);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  Color _color;
  double height = 0, width = 0;

  Widget _popUpMenu() {
    return PopupMenuButton<int>(
      onSelected: (val) {},
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: 16,
                  color: _color,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Edit",
                  style: TextStyle(fontSize: 14),
                )
              ],
            )),
        PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  size: 16,
                  color: _color,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Delete",
                  style: TextStyle(fontSize: 14),
                )
              ],
            )),
      ],
      child: Icon(MdiIcons.dotsVertical),
    );
  }

  Widget _topDetail() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.network(widget.feedDetail['facultyImg']),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.feedDetail['facultyName'].toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                widget.feedDetail['time'].toString(),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Expanded(
              child:
                  Align(alignment: Alignment.centerRight, child: _popUpMenu())),
        ],
      ),
    );
  }

  Widget _getImg(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _midDetail() {
    return SizedBox(
        height: 250.0,
        width: width,
        child: Carousel(
          images: widget.feedDetail['feedRes'].map((e) {
            return _getImg(e);
          }).toList(),
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: Theme.of(context).accentColor,
          indicatorBgPadding: 5.0,
          dotBgColor: Colors.transparent,
          borderRadius: false,
          autoplay: false,
        ));
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
            widget.feedDetail['feedTitle'].toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.feedDetail['feedDescription'].toString(),
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
              return _getDoc(widget.feedDetail['feedRes'][index]);
            },
            itemCount: widget.feedDetail['feedRes'].length));
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(FeedDetailScreen.routeName,
            arguments: widget.feedDetail);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _topDetail(),
            SizedBox(
              height: 10,
            ),
            if (widget.feedDetail['feedType'] == 'Image') _midDetail(),
            _bottomDetail(),
            if (widget.feedDetail['feedType'] == 'Document') _midPdfDetail(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
