import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/providers/categories.dart';

class CategoryWidget extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  Categories _categories;
  Color _color;
  double height = 0, width = 0;

  Widget getCategoryCard(String img, String name, String id) {
    return Card(
      child: Container(
        height: 100,
        width: width,
        child: Row(
          children: [
            Container(
              height: 100,
              width: width * 0.3,
              child: CachedNetworkImage(
                imageUrl: img,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                color: Colors.white,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Text(
                          "Join",
                          style: TextStyle(
                              color: Colors.white, letterSpacing: 1.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _categories = Provider.of<Categories>(context);
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return Container(
      child: ListView(
          children: _categories.getCategory().map((e) {
        return getCategoryCard(e.image, e.name, e.id);
      }).toList()),
    );
  }
}
