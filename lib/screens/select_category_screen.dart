import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/config/color_palette.dart';
import 'package:smvitm/models/category.dart';
import 'package:smvitm/providers/categories.dart';
import 'package:smvitm/screens/add_feed_screen.dart';

class SelectCategoryScreen extends StatelessWidget {
  static const routeName = '/selectCategory';
  String _categoryId = '';
  Categories _categories;
  List<Category> _categoryList = [];
  bool isGet = false;

  @override
  Widget build(BuildContext context) {
    _categories = Provider.of<Categories>(context);

    if (!isGet) {
      _categoryList = _categories.getCategory();
      isGet = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Category',
          style: TextStyle(
              letterSpacing: 0.2,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        titleSpacing: 0.0,
      ),
      body: GridView.builder(
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
              _categoryId = _categoryList[index].id;
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: double.infinity,
                    height: 100.0,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _Card(
                            icon: MdiIcons.text,
                            title: 'Text',
                            categoryId: _categoryId,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _Card(
                            icon: MdiIcons.image,
                            title: 'Image',
                            categoryId: _categoryId,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _Card(
                            icon: MdiIcons.fileDocument,
                            title: 'Document',
                            categoryId: _categoryId,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage:
                        CachedNetworkImageProvider(_categoryList[index].image),
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
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final IconData icon;
  final String title;
  final String categoryId;

  _Card({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.categoryId,
  }) : super(key: key);

  String _getID() {
    final box = GetStorage();
    return box.read('id');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AddFeedScreen(
                categoryId: categoryId, type: title, fid: _getID()),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30.0,
              color: ColorPalette.primaryColor,
            ),
            const SizedBox(height: 6.0),
            Text(
              title,
              style: TextStyle(
                color: ColorPalette.primaryColor,
                fontSize: 14.0,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
