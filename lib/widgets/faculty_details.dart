import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/models/faculty.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:url_launcher/url_launcher.dart';

class FacultyDetails extends StatefulWidget {
  @override
  _FacultyDetailsState createState() => _FacultyDetailsState();
}

class _FacultyDetailsState extends State<FacultyDetails> {
  Faculties _faculties;
  Color _color;
  double height = 0, width = 0;

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

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;
    _faculties = Provider.of<Faculties>(context);

    return Container(
      child: ListView(
          children: _faculties.getFaculties().map((e) {
        return _getFacultyCard(e);
      }).toList()),
    );
  }
}
