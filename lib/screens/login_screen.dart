import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smvitm/models/faculty.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/screens/main_screen.dart';
import 'package:smvitm/utility/url_utility.dart';
import 'package:smvitm/widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _idCon = TextEditingController();
  TextEditingController _passCon = TextEditingController();
  Faculties _faculties;
  bool isLoad = false;
  Color _color;

  Widget _getTextField(double width, bool obscure, String label,
      TextEditingController controller) {
    return Container(
      width: width * 0.7,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "$text",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  checkLogin() async {
    String id = _idCon.text, password = _passCon.text;

    if (id.length < 2 || password.length < 3) {
      _showSnackBar('Invalid Credentials');
    } else {
      print("$id  $password");
      setState(() {
        isLoad = true;
      });
      final response = await http.post('${UrlUtility.mainUrl}facultyLogin.php',
          body: {'faculty_id': id, 'password': password});
      setState(() {
        isLoad = false;
      });
      if (response.body == 'yes') {
        Faculty faculty = _faculties.getOneFaculty(id);
        final box = GetStorage();
        box.write('id', faculty.id);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
      } else {
        _showSnackBar('Invalid Credentials');
      }
    }
  }

  _resetPassword(String fidText) async {
    setState(() {
      isLoad = true;
    });
    final response =
        await http.post('${UrlUtility.mainUrl}sendPass.php', body: {
      'fid': fidText,
    });
    setState(() {
      isLoad = false;
    });
    if (response.body == 'yes') {
      _showSnackBar('We have mailed your login credentials');
    } else {
      _showSnackBar(
          'FID not found. Please contact app developers for more details.');
    }
  }

  void _showDialog() {
    String fidText = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Enter your Faculty ID",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: _color, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "We will send your login credentials to sode-edu E-mail associated with this ID",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    fontSize: 14),
              ),
              Container(
                  child: TextField(
                onChanged: (val) => fidText = val,
                decoration: InputDecoration(
                    hintText: 'Faculty ID', hintStyle: TextStyle(fontSize: 14)),
                keyboardType: TextInputType.number,
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Continue",
                style: TextStyle(color: _color),
              ),
              onPressed: () {
                if (fidText.length > 2) {
                  Navigator.of(context).pop();
                  _resetPassword(fidText);
                } else {
                  Navigator.of(context).pop();
                  _showSnackBar('Invalid FID');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    _faculties = Provider.of<Faculties>(context);
    _color = Theme.of(context).primaryColor;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        width: _mediaQuery.width,
        padding: EdgeInsets.symmetric(horizontal: _mediaQuery.width * 0.15),
        child: isLoad
            ? Loading()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/logo_color.png',
                    height: _mediaQuery.width * 0.2,
                    width: _mediaQuery.width * 0.2,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Faculty Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _getTextField(_mediaQuery.width, false, 'Faculty ID', _idCon),
                  SizedBox(
                    height: 10,
                  ),
                  _getTextField(_mediaQuery.width, true, 'Password', _passCon),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: _mediaQuery.width * 0.7,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        checkLogin();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      elevation: 4,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _showDialog();
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
