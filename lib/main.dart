/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen/screen.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

void main() {
  final apiModel = PhotosLibraryApiModel();
  apiModel.signInSilently();
  runApp(
    ScopedModel<PhotosLibraryApiModel>(
      model: apiModel,
      child: MyApp(),
    ),
  );
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
    print("getting settings");

    local = await SharedPreferences.getInstance();

    double brightness = await Screen.brightness;
    print("Brightness: " + brightness.toString());
    local.getBool("autoplay") == null
        ? local.setBool("autoplay", false)
        : print("autoplay set");
    local.getDouble("slideshowSpeed") == null ? local.setDouble(
        "slideshowSpeed", 60) : print("speed set");
    local.getBool("photoNotifications") == null ? local.setBool(
        "photoNotifications", true) : print("photoNotifications set");
    local.getBool("albumNotifications") == null ? local.setBool(
        "albumNotifications", true) : print("albumNotifications set");
    local.getDouble("brightness") == null ? local.setDouble("brightness", brightness) : print(
        "brightness set");
  }
}
