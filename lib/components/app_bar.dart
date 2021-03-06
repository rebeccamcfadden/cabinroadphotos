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

import 'package:cabinroadphotos2/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/pages/login_page.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';

class PhotoAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder:
          (BuildContext context, Widget child, PhotosLibraryApiModel apiModel) {
        return AppBar(
          title: Row(
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  'assets/ic_cabinrdphoto.svg',
                  width: 48,
                  height: 48,
                  excludeFromSemantics: true,
                  color: Colors.green[800],
                ),
                padding: const EdgeInsets.only(right: 8),
              ),
              Text(
                'Cabin Road Photos',
              ),
            ],
          ),
          actions: _buildActions(apiModel, context),
        );
      },
    );
  }

  List<Widget> _buildActions(
      PhotosLibraryApiModel apiModel, BuildContext context) {
    final List<Widget> widgets = <Widget>[];

    if (apiModel.isLoggedIn()) {
      if (apiModel.user.photoUrl != null) {
        widgets.add(Container(
          child: CircleAvatar(
            radius: 14,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                apiModel.user.photoUrl,
              ),
            ),
          ),
        ));
      } else {
        // Placeholder to use when there is no photo URL.
        final List<String> placeholderCharSources = <String>[
          apiModel.user.displayName,
          apiModel.user.email,
          '-',
        ];
        final String placeholderChar = placeholderCharSources
            .firstWhere(
                (String str) => str != null && str.trimLeft().isNotEmpty)
            .trimLeft()[0]
            .toUpperCase();

        widgets.add(
          Container(
            height: 6,
            child: CircleAvatar(
              child: Text(placeholderChar),
            ),
          ),
        );
      }

      widgets.add(
        PopupMenuButton<_AppBarOverflowOptions>(
          onSelected: (_AppBarOverflowOptions selection) async {
            switch(selection) {
              case _AppBarOverflowOptions.signout:
                await apiModel.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  ),
                );
                break;
              case _AppBarOverflowOptions.settings:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage(),
                  ),
                );
                break;
            }

          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<_AppBarOverflowOptions>>[
              PopupMenuItem<_AppBarOverflowOptions>(
                value: _AppBarOverflowOptions.signout,
                child: const Text('Disconnect from Google Photos'),
              ),
              PopupMenuItem<_AppBarOverflowOptions>(
                value: _AppBarOverflowOptions.settings,
                child: const Text('Settings'),
              )
            ];
          },
        ),
      );
    }

    return widgets;
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

enum _AppBarOverflowOptions {
  signout,
  settings
}
