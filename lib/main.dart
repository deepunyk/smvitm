import 'package:flutter/material.dart';
import 'package:smvitm/config/color_palette.dart';
import 'package:smvitm/screens/splash_screen.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    theme: ThemeData(
      primaryColor: ColorPalette.primaryColor,
      accentColor: ColorPalette.accentColor,
      fontFamily: 'OpenSans',
    ),
  ));
}
