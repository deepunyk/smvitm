import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/models/faculty.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:url_launcher/url_launcher.dart';

class FacultyDetailScreen extends StatefulWidget {
  static const routeName = 'facultyDetail';

  @override
  _FacultyDetailScreenState createState() => _FacultyDetailScreenState();
}

class _FacultyDetailScreenState extends State<FacultyDetailScreen> {
  Faculties _faculties;
  Color _color;
  double height = 0, width = 0;
  String _searchValue = "";

  Widget _getFacultyCard(Faculty faculty) {
    return Card(
      child: ListTile(
        leading: Container(
          height: 70,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: faculty.photo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(faculty.name),
        subtitle: Text(faculty.designation),
        trailing: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  launch(Uri(
                    scheme: 'mailto',
                    path: faculty.email,
                  ).toString());
                },
                icon: Icon(
                  Icons.mail,
                  color: _color,
                ),
              ),
              IconButton(
                onPressed: () {
                  launch("tel://${faculty.phone}");
                },
                icon: Icon(
                  Icons.call,
                  color: _color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getList() {
    if (_faculties.searchFaculty(_searchValue).length > 0) {
      return ListView(
          children: _faculties.searchFaculty(_searchValue).map((e) {
        return _getFacultyCard(e);
      }).toList());
    } else {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No faculty with this name found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;
    _faculties = Provider.of<Faculties>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: _color,
        ),
        title: TextField(
          autofocus: true,
          onChanged: (val) {
            _searchValue = val;
            setState(() {});
          },
        ),
      ),
      body: _getList(),
    );
  }
}
