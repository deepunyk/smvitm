import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/models/category.dart';
import 'package:smvitm/providers/categories.dart';

class CategoryWidget extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  Categories _categories;
  Color _color;
  double height = 0, width = 0;
  List<Category> _categoryList = [];
  bool isGet = false;

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

    if (!isGet) {
      _categoryList = _categories.getCategory();
      isGet = true;
    }

    return Container(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage:
                            NetworkImage(_categoryList[index].image),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        _categoryList[index].name,
                        style: TextStyle(
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _categoryList[index].isSelect =
                            !_categoryList[index].isSelect;
                      });
                    },
                    icon: Transform.rotate(
                      angle: math.pi / 4,
                      child: Icon(
                        MdiIcons.pin,
                        color: _categoryList[index].isSelect
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    iconSize: 24.0,
                  ),
                ),
              ],
            ),
          );
        },
      ), /*ListView(
          children: _categories.getCategory().map((e) {
        return getCategoryCard(e.image, e.name, e.id);
      }).toList()),*/
    );
  }
}
