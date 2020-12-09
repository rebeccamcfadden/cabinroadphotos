import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen/screen.dart';

// void main() => runApp(InitializationApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InitializationApp());
}

class InitializationApp extends StatelessWidget {

  final apiModel = PhotosLibraryApiModel();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: initialize(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return ScopedModel<PhotosLibraryApiModel>(
              model: apiModel,
              child: MyApp(),
            );
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }

  Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  _registerServices() async {
    print("starting registering services");
    // await Firebase.initializeApp();
    apiModel.signInSilently();
    print("finished registering services");
  }

  _loadSettings() async {
    print("starting loading settings");
    Preferences.local = await SharedPreferences.getInstance();
    Preferences.init();
    print("finished loading settings");
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Initialization",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final ThemeData _theme = _buildTheme();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Cabin Road Photos',
      theme: _theme,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.white,
    primaryColorBrightness: Brightness.light,
    primaryTextTheme: Typography.blackMountainView,
    primaryIconTheme: const IconThemeData(
      color: Colors.grey,
    ),
    accentColor: Colors.green[800],
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: Colors.green[800],
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}

class Preferences {
  static SharedPreferences local;

  /// Initializes the Shared Preferences and sets the info towards a global variable
  static Future init() async {
    double brightness = await Screen.brightness;
    // print("Brightness: " + brightness.toString());
    local.getBool("autoplay") == null
        ? local.setBool("autoplay", false)
        : print("autoplay set");
    local.getBool("autoplaySlideshow") == null
        ? local.setBool("autoplaySlideshow", true)
        : print("autoplaySlideshow set");
    local.getDouble("slideshowSpeed") == null ? local.setDouble(
        "slideshowSpeed", 60) : print("speed set");
    local.getBool("photoNotifications") == null ? local.setBool(
        "photoNotifications", true) : print("photoNotifications set");
    local.getBool("albumNotifications") == null ? local.setBool(
        "albumNotifications", true) : print("albumNotifications set");
    local.getDouble("brightness") == null ? local.setDouble("brightness", brightness) : print(
        "brightness set");
    local.getBool("preventDim") == null
        ? local.setBool("preventDim", true)
        : print("preventDim set");
  }
}
