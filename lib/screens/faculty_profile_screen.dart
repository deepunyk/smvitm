import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/models/faculty.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/screens/splash_screen.dart';
import 'package:smvitm/widgets/loading.dart';

class FacultyProfileScreen extends StatefulWidget {
  static const routeName = '/facultyProfile';
  static bool isEdit = false;

  @override
  _FacultyProfileScreenState createState() => _FacultyProfileScreenState();
}

class _FacultyProfileScreenState extends State<FacultyProfileScreen> {
  Faculties _faculties;
  bool code = false;
  Faculty faculty;
  bool isLoad = false;
  String photoUrl = "";
  TextEditingController _name = TextEditingController();
  TextEditingController _designation = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File _file;

  getData() {
    final box = GetStorage();
    faculty = _faculties.getOneFaculty(box.read('id'));
    _name.text = faculty.name;
    _designation.text = faculty.designation;
    _email.text = faculty.email;
    _phone.text = faculty.phone;
    _password.text = faculty.password;
    photoUrl = faculty.photo;
  }

  @override
  Widget build(BuildContext context) {
    _faculties = Provider.of<Faculties>(context);

    if (!code) {
      code = !code;
      getData();
    }

    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        titleSpacing: 0,
        title: Text(
          'Profile',
          style: TextStyle(
              letterSpacing: 0.2,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoad
          ? Loading()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: _mediaQuery.height * 0.26,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: _mediaQuery.width,
                          height: _mediaQuery.height * 0.18,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/college_bck.jpg',
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                width: _mediaQuery.width,
                                height: _mediaQuery.height * 0.18,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Hero(
                              tag: 'imgTag',
                              child: CircleAvatar(
                                radius: 56.0,
                                backgroundColor: Colors.grey,
                                backgroundImage: _file == null
                                    ? NetworkImage(photoUrl)
                                    : FileImage(_file),
                              ),
                            ),
                          ),
                        ),
                        if (FacultyProfileScreen.isEdit)
                          Positioned(
                            left: 80,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    _file = await FilePicker.getFile(
                                        type: FileType.image);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    MdiIcons.camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _InputField(controller: _name, label: 'Name'),
                  const SizedBox(height: 6.0),
                  _InputField(controller: _designation, label: 'Designation'),
                  const SizedBox(height: 6.0),
                  _InputField(controller: _email, label: 'Email'),
                  const SizedBox(height: 6.0),
                  _InputField(controller: _phone, label: 'Phone'),
                  const SizedBox(height: 6.0),
                  _InputField(
                      controller: _password,
                      label: 'Password',
                      isPassword: true),
                  const SizedBox(height: 6.0),
                  InkWell(
                    onTap: () {
                      if (FacultyProfileScreen.isEdit) {
                        _updateProfile();
                      } else {
                        setState(() {
                          FacultyProfileScreen.isEdit = true;
                        });
                      }
                    },
                    child: Container(
                      width: _mediaQuery.width,
                      height: 50.0,
                      margin: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Center(
                        child: Text(
                          FacultyProfileScreen.isEdit
                              ? 'SAVE CHANGES'
                              : 'EDIT PROFILE',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.6,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
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
        backgroundColor: Colors.red.shade900,
        duration: Duration(seconds: 1),
      ),
    );
  }

  _updateProfile() async {
    if (_name.text.length <= 0 ||
        _designation.text.length <= 0 ||
        _email.text.length <= 0 ||
        _phone.text.length <= 0 ||
        _password.text.length <= 0) {
      _showSnackBar('Please fill all the fields');
    } else {
      _submit();
    }
  }

  _submit() async {
    final box = GetStorage();
    String facId = box.read('id');
    String _base64;
    if (_file != null) {
      _base64 = base64.encode(_file.readAsBytesSync());
    }
    setState(() {
      isLoad = true;
    });
    http.Response response = await http
        .post('http://smvitmapp.xtoinfinity.tech/php/editFaculty.php', body: {
      'faculty_name': _name.text,
      'faculty_desgination': _designation.text,
      'faculty_email': _email.text,
      'faculty_phone': _phone.text,
      'password': _password.text,
      'faculty_id': facId,
      'faculty_photo': _file != null ? _base64 : 'no',
    });
    setState(() {
      isLoad = false;
    });
    print(response.body.toString());

    if (response.body.toString() == 'yes') {
      //Navigator.pop(context);
      setState(() {
        FacultyProfileScreen.isEdit = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
    } else {
      _showSnackBar('Something went wrong... Please try again');
    }
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool isPassword;

  const _InputField({
    Key key,
    @required this.controller,
    @required this.label,
    this.maxLines = 1,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextField(
        enabled: FacultyProfileScreen.isEdit,
        controller: controller,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        obscureText: isPassword,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            letterSpacing: 1,
            color: Theme.of(context).primaryColor),
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
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
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
