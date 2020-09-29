import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smvitm/screens/splash_screen.dart';
import 'package:smvitm/utility/url_utility.dart';
import 'package:smvitm/widgets/loading.dart';

class AddFeedScreen extends StatefulWidget {
  final String categoryId, type, fid;

  const AddFeedScreen({
    Key key,
    @required this.categoryId,
    @required this.type,
    @required this.fid,
  }) : super(key: key);

  @override
  _AddFeedScreenState createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  List<File> _files;
  List<String> _base64 = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _imageFormats = ['jpg', 'jpeg', 'png'];
  List<String> _documentFormats = ['pdf', 'doc'];
  List<Map<String, String>> _listOfMap = [];
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Feed',
          style: TextStyle(
              letterSpacing: 0.2,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        titleSpacing: 0.0,
        actions: [
          if (widget.type != 'Text')
            IconButton(
              onPressed: () async {
                _files = await FilePicker.getMultiFile(
                  type: FileType.custom,
                  allowedExtensions:
                      widget.type == 'Image' ? _imageFormats : _documentFormats,
                );
                setState(() {});
              },
              icon: Icon(
                MdiIcons.attachment,
                color: Theme.of(context).primaryColor,
              ),
            )
        ],
      ),
      body: isLoad
          ? Loading()
          : Container(
              height: _mediaQuery.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 6.0),
                  _InputField(controller: _title, label: 'Title'),
                  const SizedBox(height: 10.0),
                  _InputField(
                    controller: _description,
                    label: 'Description',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 20.0),
                  if (_files != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _files.length,
                        itemBuilder: (context, index) {
                          String fileName = _files[index].toString();
                          return ListTile(
                            title: Text(
                              fileName.substring(fileName.lastIndexOf('/') + 1,
                                  fileName.lastIndexOf('\'')),
                              maxLines: 2,
                              style: TextStyle(),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _files.removeAt(index);
                                });
                              },
                              icon: Icon(MdiIcons.fileRemove),
                            ),
                          );
                        },
                      ),
                    ),
                  _Button(title: 'SUBMIT', onTap: _submit),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
    );
  }

  _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _submit() async {
    if (_title.text == null || _title.text.length <= 0) {
      _showSnackBar('Please enter the title');
    } else if (_description.text == null || _description.text.length <= 0) {
      _showSnackBar('Please enter the description');
    } else if (widget.type != 'Text' &&
        (_files == null || _files.length == 0)) {
      _showSnackBar('Please attach a file');
    } else {
      if (widget.type != 'Text') {
        for (var i = 0; i < _files.length; i++) {
          _base64.insert(i, base64.encode(_files[i].readAsBytesSync()));
        }
      }
      _base64
          .map((e) => {
                _listOfMap.add({'res': e})
              })
          .toList();
      setState(() {
        isLoad = true;
      });
      http.Response response =
          await http.post('${UrlUtility.mainUrl}addFeed.php', body: {
        'category_id': widget.categoryId,
        'feed_title': _title.text,
        'feed_description': _description.text,
        'feed_type': widget.type,
        'faculty_id': widget.fid,
        'feed_res':
            widget.type == 'Text' ? '' : JsonEncoder().convert(_listOfMap),
        'type': widget.type,
        'feed_time': DateTime.now().toString(),
      });
      print(response.body.toString());

      if (response.body.toString() == 'yes') {
        await FirebaseFirestore.instance.collection('notification').add({
          'title': _title.text,
          'body': _description.text,
          'to': widget.categoryId,
        });
        setState(() {
          isLoad = false;
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
      } else {
        _showSnackBar('Something went wrong... Please try again');
        setState(() {
          isLoad = false;
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
      }
    }
  }
}

class _Button extends StatelessWidget {
  final String title;
  final Function onTap;

  const _Button({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.0,
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2.0)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const _InputField({
    Key key,
    @required this.controller,
    @required this.label,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          letterSpacing: 1,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          alignLabelWithHint: true,
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            letterSpacing: 1,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
