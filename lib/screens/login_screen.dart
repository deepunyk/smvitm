import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget _getTextField(double width, bool obscure, String label) {
    return Container(
      width: width * 0.7,
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: _mediaQuery.width,
        padding: EdgeInsets.symmetric(horizontal: _mediaQuery.width*0.15),
        child: Column(
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
            _getTextField(_mediaQuery.width, false, 'Faculty ID'),
            SizedBox(
              height: 10,
            ),
            _getTextField(_mediaQuery.width, true, 'Password`'),
            SizedBox(
              height: 20,
            ),
            Container(
              width: _mediaQuery.width * 0.7,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {},
                child: Text(
                  "Login",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                color: Colors.white,
                elevation: 4,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
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
