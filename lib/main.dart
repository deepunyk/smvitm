import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/config/color_palette.dart';
import 'package:smvitm/providers/categories.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';
import 'package:smvitm/providers/feeds.dart';
import 'package:smvitm/screens/faculty_detail_screen.dart';
import 'package:smvitm/screens/feed_detail_screen.dart';
import 'package:smvitm/screens/image_view_screen.dart';
import 'package:smvitm/screens/login_screen.dart';
import 'package:smvitm/screens/main_screen.dart';
import 'package:smvitm/screens/pdf_view_screen.dart';
import 'package:smvitm/screens/splash_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (ctx) => Faculties(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => Categories(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => Feeds(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => FeedResources(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
        accentColor: ColorPalette.accentColor,
        fontFamily: 'OpenSans',
      ),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SplashScreen.routeName: (ctx) => SplashScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
        FeedDetailScreen.routeName: (ctx) => FeedDetailScreen(),
        PDFViewScreen.routeName: (ctx) => PDFViewScreen(),
        FacultyDetailScreen.routeName: (ctx) => FacultyDetailScreen(),
        ImageViewScreen.routeName: (ctx) => ImageViewScreen(),
      },
    ),
  ));
}
