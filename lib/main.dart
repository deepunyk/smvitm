import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smvitm/config/color_palette.dart';
import 'package:smvitm/providers/categories.dart';
import 'package:smvitm/providers/faculties.dart';
import 'package:smvitm/providers/feed_resources.dart';
import 'package:smvitm/providers/feeds.dart';
import 'package:smvitm/screens/faculty_detail_screen.dart';
import 'package:smvitm/screens/faculty_profile_screen.dart';
import 'package:smvitm/screens/feed_detail_screen.dart';
import 'package:smvitm/screens/image_view_screen.dart';
import 'package:smvitm/screens/login_screen.dart';
import 'package:smvitm/screens/main_screen.dart';
import 'package:smvitm/screens/pdf_view_screen.dart';
import 'package:smvitm/screens/select_category_screen.dart';
import 'package:smvitm/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await GetStorage.init();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
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
        home: SplashScreen(
          loading: false,
        ),
        theme: ThemeData(
          primaryColor: ColorPalette.primaryColor,
          accentColor: ColorPalette.accentColor,
          fontFamily: 'OpenSans',
        ),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          SplashScreen.routeName: (context) => SplashScreen(),
          MainScreen.routeName: (context) => MainScreen(),
          FeedDetailScreen.routeName: (context) => FeedDetailScreen(),
          PDFViewScreen.routeName: (context) => PDFViewScreen(),
          FacultyDetailScreen.routeName: (context) => FacultyDetailScreen(),
          ImageViewScreen.routeName: (context) => ImageViewScreen(),
          SelectCategoryScreen.routeName: (context) => SelectCategoryScreen(),
          FacultyProfileScreen.routeName: (context) => FacultyProfileScreen(),
        },
      ),
    ),
  );
}
