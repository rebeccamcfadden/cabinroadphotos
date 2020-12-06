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
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/components/primary_raised_button.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/photos_library_api/album.dart';

// import '../util/to_be_implemented.dart';

class CreateAlbumPage extends StatefulWidget {
  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController albumNameFormController = TextEditingController();

  @override
  void dispose() {
    albumNameFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(overflow: Overflow.visible, children: <Widget>[
        Positioned(
          right: 10.0,
          top: 10.0,
          child: InkResponse(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              child: Icon(Icons.close),
              foregroundColor: Colors.blueGrey,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(25),
          child: _isLoading
              ? Center(child: const CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: albumNameFormController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Album name',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 0,
                        ),
                        child: const Text(
                          'This will create a shared album in your Google Photos'
                          ' account',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Center(
                        child: PrimaryRaisedButton(
                          onPressed: () => _createAlbum(context),
                          label: const Text('Create Album'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ]),
    );
  }

  Future<void> _createAlbum(BuildContext context) async {
    // Display the loading indicator.

    setState(() => _isLoading = true);

    await ScopedModel.of<PhotosLibraryApiModel>(context)
        .createAlbum(albumNameFormController.text)
        .then((Album album) {
          // Hide the loading indicator.
          setState(() => _isLoading = false);
          Navigator.of(context).pop();
        }
    );
  }
}
