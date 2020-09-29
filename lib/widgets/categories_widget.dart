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

  _showSubscribeSnack(String name, BuildContext ctx) {
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          "You have $name",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(ctx).primaryColor,
        duration: Duration(seconds: 1),
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
      child: LayoutBuilder(
        builder: (ctx, constraints) => GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  if (_categories
                      .getSelectedList()
                      .contains(_categoryList[index].id)) {
                    _showSubscribeSnack(
                        "unsubscribed from ${_categoryList[index].name}", ctx);
                    _categories.removeSelectedCategory(_categoryList[index].id);
                  } else {
                    _showSubscribeSnack(
                        "subscribed to ${_categoryList[index].name}", ctx);
                    _categories.addSelectedCategory(_categoryList[index].id);
                  }
                });
              },
              child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: CachedNetworkImageProvider(
                                _categoryList[index].image),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            _categoryList[index].name,
                            style: TextStyle(
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Transform.rotate(
                        angle: math.pi / 4,
                        child: Icon(
                          MdiIcons.pin,
                          color: _categories
                                  .getSelectedList()
                                  .contains(_categoryList[index].id)
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
