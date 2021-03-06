import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_string_res/flutter_native_string_res.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen/screen.dart';

// void main() => runApp(InitializationApp());
String webClientId;
GoogleSignIn _googleSignIn;
FirebaseAuth _auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  webClientId = await NativeStringResource(androidName: "default_web_client_id").value;
  print("WEB CLIENT ID RECEIVED: " + webClientId);
  _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'profile',
        'email',
        'https://www.googleapis.com/auth/gmail.modify',
        'https://www.googleapis.com/auth/photoslibrary',
        'https://www.googleapis.com/auth/photoslibrary.sharing'
      ],
      clientId: webClientId
  );
  _auth = FirebaseAuth.instance;
  runApp(InitializationApp());
}

class InitializationApp extends StatelessWidget {
  final apiModel = PhotosLibraryApiModel(webClientId, _googleSignIn, _auth);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cabin Road Photos',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
            "Cabin Road Photos",
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
    local.getString("emailAddressToAdd") == null
        ? local.setString("emailAddressToAdd", "") : print(
        "emailAddressToAdd set");
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
    local.getDouble("brightness") == null ? local.setDouble(
        "brightness", brightness) : print(
        "brightness set");
    local.getBool("preventDim") == null
        ? local.setBool("preventDim", true)
        : print("preventDim set");
    Screen.keepOn(local.getBool("preventDim"));
  }
}
