import 'dart:ffi';

import 'package:cabinroadphotos2/main.dart';
import 'package:flutter/material.dart';
import 'package:cabinroadphotos2/components/app_bar.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

// import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:screen/screen.dart';

import 'album_display_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  initState() {
    _initializeSettings();
    super.initState();
  }

  Future _initializeSettings() async {
    print("getting settings");
    if (Preferences.local == null) {
      await Preferences.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: "Application Settings", children: [
      SettingsTileGroup(
        title: 'General',
        children: [
          SimpleSettingsTile(
            title: 'Notifications',
            screen: SettingsScreen(
              title: 'Notifications settings',
              children: [
                SwitchSettingsTile(
                    settingKey: 'photoNotifications',
                    title: 'New photo notifications',
                    defaultValue: Preferences.local.getBool("photoNotifications"),
                    icon: Icon(Icons.photo)
                ),
                SwitchSettingsTile(
                    settingKey: 'albumNotifications',
                    title: 'New album notifications',
                    defaultValue: Preferences.local.getBool("albumNotifications"),
                    icon: Icon(Icons.photo_album)
                ),
              ],
            )
          ),
          SwitchSettingsTile(
              settingKey: 'preventDim',
              title: 'Prevent dimming',
              defaultValue: true,
              icon: Icon(Icons.brightness_2)
          ),
          Settings().onBoolChanged(
            settingKey: 'preventDim',
            childBuilder: (BuildContext context, bool value) {
              Screen.keepOn(value);
              return Container();
            },
          ),
          SliderSettingsTile(
            settingKey: 'brightness',
            title: 'Brightness',
            minIcon: Icon(Icons.brightness_4),
            maxIcon: Icon(Icons.brightness_7),
            minValue: 0.0,
            maxValue: 1.0,
            step: 0.05,
            defaultValue: Preferences.local.getDouble("brightness"),
          ),
          Settings().onDoubleChanged(
            settingKey: 'brightness',
            childBuilder: (BuildContext context, double value) {
              Screen.setBrightness(value);
              return Container();
            },
          )
        ],
      ),
      SettingsTileGroup(
        title: "Slideshow",
        children: [
          SwitchSettingsTile(
              settingKey: 'autoplay',
              title: 'Autoplay videos',
              defaultValue: Preferences.local.getBool("autoplay"),
              icon: Icon(Icons.play_arrow)
          ),
          SliderSettingsTile(
            settingKey: 'slideshowSpeed',
            title: 'Slideshow speed (seconds)',
            icon: Icon(Icons.speed),
            minValue: 10.0,
            maxValue: 600.0,
            step: 5.0,
            defaultValue: Preferences.local.getDouble("slideshowSpeed"),
          ),
        ]
      ),
      SettingsTileGroup(
        title: "Authorized email addresses",
        children: [
          Text("TODO")
        ]
      )
    ]);
  }
}
