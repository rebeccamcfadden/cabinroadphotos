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

import 'dart:collection';
import 'dart:io';

import 'package:cabinroadphotos2/main.dart';
import 'package:cabinroadphotos2/photos_library_api/album.dart';
import 'package:cabinroadphotos2/photos_library_api/batch_create_media_items_request.dart';
import 'package:cabinroadphotos2/photos_library_api/batch_create_media_items_response.dart';
import 'package:cabinroadphotos2/photos_library_api/create_album_request.dart';
import 'package:cabinroadphotos2/photos_library_api/get_album_request.dart';
import 'package:cabinroadphotos2/photos_library_api/list_albums_response.dart';
import 'package:cabinroadphotos2/photos_library_api/list_shared_albums_response.dart';
import 'package:cabinroadphotos2/photos_library_api/media_item.dart';
import 'package:cabinroadphotos2/photos_library_api/search_media_items_request.dart';
import 'package:cabinroadphotos2/photos_library_api/search_media_items_response.dart';
import 'package:cabinroadphotos2/photos_library_api/list_media_items_request.dart';
import 'package:cabinroadphotos2/photos_library_api/list_media_items_response.dart';
import 'package:cabinroadphotos2/photos_library_api/share_album_request.dart';
import 'package:cabinroadphotos2/photos_library_api/share_album_response.dart';
import 'package:flutter_native_string_res/flutter_native_string_res.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/photos_library_api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotosLibraryApiModel extends Model {
  final String webClientId;
  final _googleSignIn;
  final FirebaseAuth _auth;

  PhotosLibraryApiModel(this.webClientId, this._googleSignIn, this._auth) {
    _auth.idTokenChanges().listen((event) async {
      await refreshToken();
    });
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      _currentUser = account;

      if (_currentUser != null) {
        // Initialize the client with the new user credentials
        client = PhotosLibraryApiClient(_currentUser);

        final GoogleSignInAuthentication googleSignInAuthentication =
        await _currentUser.authentication;

        print("SERVER CODE");
        print(googleSignInAuthentication.serverAuthCode);
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
        await _auth.signInWithCredential(credential);

        final User firebaseUser = authResult.user;

        if (firebaseUser != null) {
          assert(!firebaseUser.isAnonymous);
          assert(await firebaseUser.getIdToken() != null);

          final User firebaseCurrentUser = _auth.currentUser;
          assert(firebaseUser.uid == firebaseCurrentUser.uid);

          print('signInWithGoogle succeeded: $firebaseUser');
          functions = FirebaseFunctions.instance;
          if(googleSignInAuthentication.serverAuthCode != null) {
            await FirebaseFirestore.instance.collection("authentication")
                .doc(_currentUser.email).set({
              'token': googleSignInAuthentication.serverAuthCode
            }).then((value) => print("Token updated"))
                .catchError((error) => print("Failed to update token: $error"));
          }
        }
      } else {
        // Reset the client
        client = null;
      }

      // Reinitialize the albums
      updateAlbums();

      notifyListeners();
    });
  }

  final LinkedHashSet<Album> _albums = LinkedHashSet<Album>();
  bool hasAlbums = false;
  PhotosLibraryApiClient client;
  List<MediaItem> fullLibrary;
  Album fullLibraryAlbum;

  // var sharedPreferences;

  GoogleSignInAccount _currentUser;

  FirebaseFunctions functions;

  GoogleSignInAccount get user => _currentUser;

  bool isLoggedIn() {
    return _currentUser != null;
  }

  Future<bool> signIn() async {
    final GoogleSignInAccount user = await _googleSignIn.signIn();
    if (user == null) {
      // User could not be signed in
      print('User could not be signed in.');
      return false;
    }

    print('User signed in.');
    return true;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();

  }

  Future<void> signInSilently() async {
    final GoogleSignInAccount user = await _googleSignIn.signInSilently();
    if (_currentUser == null) {
      // User could not be signed in
      return;
    }
    print('User signed in silently.');
  }

  Future<String> refreshToken() async {
    final GoogleSignInAccount googleSignInAccount =
    await _googleSignIn.signInSilently();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await _auth.signInWithCredential(credential);

    return googleSignInAuthentication.accessToken; //new token
  }

  Future<Album> createAlbum(String title) async {
    return client
        .createAlbum(CreateAlbumRequest.fromTitle(title))
        .then((Album album) {
      updateAlbums();
      return album;
    });
  }

  Future<Album> getAlbum(String id) async {
    return client
        .getAlbum(GetAlbumRequest.defaultOptions(id))
        .then((Album album) {
      return album;
    });
  }

  Future<ShareAlbumResponse> shareAlbum(String id) async {
    return client
        .shareAlbum(ShareAlbumRequest.defaultOptions(id))
        .then((ShareAlbumResponse response) {
      updateAlbums();
      return response;
    });
  }

  Future<SearchMediaItemsResponse> searchMediaItems(String albumId) async {
    if (albumId == "fullLibraryAlbum") {
      return SearchMediaItemsResponse(fullLibrary, null);
    }
    return client
        .searchMediaItems(SearchMediaItemsRequest.albumId(albumId))
        .then((SearchMediaItemsResponse response) {
      return response;
    });
  }

  Future<ListMediaItemsResponse> listMediaItems() async {
    return client
        .listMediaItems(ListMediaItemsRequest.def())
        .then((ListMediaItemsResponse response) {
      return response;
    });
  }

  Future<String> uploadMediaItem(File image) {
    return client.uploadMediaItem(image);
  }

  Future<BatchCreateMediaItemsResponse> createMediaItem(
      String uploadToken, String albumId, String description) {
    // Construct the request with the token, albumId and description.
    final BatchCreateMediaItemsRequest request =
        BatchCreateMediaItemsRequest.inAlbum(uploadToken, albumId, description);

    // Make the API call to create the media item. The response contains a
    // media item.
    return client
        .batchCreateMediaItems(request)
        .then((BatchCreateMediaItemsResponse response) {
      // Print and return the response.
      print(response.newMediaItemResults[0].toJson());
      return response;
    });
  }

  UnmodifiableListView<Album> get albums =>
      UnmodifiableListView<Album>(_albums ?? <Album>[]);

  void updateAlbums() async {
    // Reset the flag before loading new albums
    hasAlbums = false;
    // print("updating albums");

    // Clear all albums
    _albums.clear();

    // Skip if not signed in
    if (!isLoggedIn()) {
      return;
    }

    // Add albums from the user's Google Photos account
    var ownedAlbums = await _loadAlbums();
    if (ownedAlbums != null) {
      _albums.addAll(ownedAlbums);
    }

    // Load albums from owned and shared albums
    final List<List<Album>> list =
        await Future.wait([_loadSharedAlbums(), _loadAlbums()]);

    final ListMediaItemsResponse allMediaItems = await listMediaItems();
    fullLibrary = allMediaItems.mediaItems;
    fullLibraryAlbum = Album(
        "fullLibraryAlbum",
        "FULL LIBRARY",
        null,
        false,
        null,
        fullLibrary.length.toString(),
        fullLibrary.first.baseUrl,
        fullLibrary.first.id);

    _albums.addAll(list.expand((a) => a ?? []));
    _albums.add(fullLibraryAlbum);

    notifyListeners();
    hasAlbums = true;
  }

  // /// Load Albums into the model by retrieving the list of all albums shared
  // /// with the user.
  Future<List<Album>> _loadSharedAlbums() {
    return client.listSharedAlbums().then(
      (ListSharedAlbumsResponse response) {
        return response.sharedAlbums;
      },
    );
  }

  /// Load albums into the model by retrieving the list of all albums owned
  /// by the user.
  Future<List<Album>> _loadAlbums() {
    return client.listAlbums().then(
      (ListAlbumsResponse response) {
        return response.albums;
      },
    );
  }
}
