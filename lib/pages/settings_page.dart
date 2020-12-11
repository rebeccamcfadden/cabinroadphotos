import 'dart:ffi';

import 'package:cabinroadphotos2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Settings;
import 'package:flutter/material.dart';
import 'package:cabinroadphotos2/components/app_bar.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

// import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:screen/screen.dart';

import 'album_display_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  CollectionReference authorizedEmails =
      FirebaseFirestore.instance.collection('authorizedEmails');
  List<String> emailList;

  @override
  initState() {
    super.initState();
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
                      defaultValue:
                          Preferences.local.getBool("photoNotifications"),
                      icon: Icon(Icons.photo)),
                  SwitchSettingsTile(
                      settingKey: 'albumNotifications',
                      title: 'New album notifications',
                      defaultValue:
                          Preferences.local.getBool("albumNotifications"),
                      icon: Icon(Icons.photo_album)),
                ],
              )),
          SwitchSettingsTile(
              settingKey: 'preventDim',
              title: 'Prevent dimming',
              defaultValue: true,
              icon: Icon(Icons.brightness_2)),
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
            defaultValue: Preferences.local.getDouble("brightness"),
            childBuilder: (BuildContext context, double value) {
              Screen.setBrightness(value);
              return Container();
            },
          )
        ],
      ),
      SettingsTileGroup(title: "Slideshow", children: [
        SwitchSettingsTile(
            settingKey: 'autoplay',
            title: 'Autoplay videos',
            defaultValue: Preferences.local.getBool("autoplay"),
            icon: Icon(Icons.play_arrow)),
        SliderSettingsTile(
          settingKey: 'slideshowSpeed',
          title: 'Slideshow speed (seconds)',
          icon: Icon(Icons.speed),
          minValue: 10.0,
          maxValue: 600.0,
          step: 5.0,
          defaultValue: Preferences.local.getDouble("slideshowSpeed"),
        ),
      ]),
      StreamBuilder<QuerySnapshot>(
        stream: authorizedEmails.snapshots(),
        builder: _buildAuthorizedEmails,
      ),
      FlatButton(
          child: Row(
            children: [
              Icon(Icons.person_add_alt_1),
              SizedBox(width: 5,),
              Text("Add authorized email address")
            ],
          ),
          onPressed: _showDialog
      ),
    ]);
  }

  void _showDialog() async {
    TextEditingController _controller = new TextEditingController();
    await showDialog<String>(
        context: context,
        child: new AlertDialog(
          title: Text("Add Authorized Email"),
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Email address', hintText: 'eg. me@gmail.com'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                }),
            new FlatButton(
                child: const Text('SUBMIT'),
                onPressed: () async {
                  print("Dialog finished: " + _controller.text);
                  await addEmail(_controller.text, ["receivedPhotos"]);
                  Navigator.of(context, rootNavigator: true).pop();
                })
          ],
        ));
  }

  Future<void> addEmail(String email, List<String> album) {
    if (email == "" || email == null) {
      return null;
    }
    // Call the user's CollectionReference to add a new user
    return authorizedEmails
        .add({
          'email': email, // John Doe
          'album': FieldValue.arrayUnion(album)
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Widget _buildAuthorizedEmails(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return Text('Something went wrong');
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("Loading");
    }

    if (snapshot.hasData) {
      if (snapshot.data.docs.length == 0) {
        return Container();
      }
      return new SettingsTileGroup(
        title: "Authorized email addresses",
        children: snapshot.data.docs.map((DocumentSnapshot document) {
          String email = document.data()['email'];
          if (email != null) {
            return new SimpleSettingsTile(
            title: email,
            screen: SettingsScreen(
                title: "Select albums for " + email,
                children: [
                CheckboxSettingsTile(
                settingKey: 'key-of-your-setting',
                title: 'This is a simple Checkbox',
            ),
          ]));
          } else {
            return Container();
          }
        }).toList(),
      );
    } else {
      return Container();
    }
  }
}
