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

import 'dart:convert';
import 'dart:io';

import 'package:cabinroadphotos2/photos_library_api/list_media_items_request.dart';
import 'package:cabinroadphotos2/photos_library_api/list_media_items_response.dart';
import 'package:cabinroadphotos2/photos_library_api/search_media_items_request.dart';
import 'package:cabinroadphotos2/photos_library_api/search_media_items_response.dart';
import 'package:cabinroadphotos2/photos_library_api/share_album_request.dart';
import 'package:cabinroadphotos2/photos_library_api/share_album_response.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:cabinroadphotos2/photos_library_api/album.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'album.dart';
import 'batch_create_media_items_request.dart';
import 'batch_create_media_items_response.dart';
import 'create_album_request.dart';
import 'get_album_request.dart';
import 'list_albums_response.dart';
import 'list_shared_albums_response.dart';

class PhotosLibraryApiClient {
  PhotosLibraryApiClient(this._currentUser);

  // Future<Map<String, String>> _authHeaders;
  GoogleSignInAccount _currentUser;
  
  Future<Map<String, String>> getAuthHeaders() async {
    return await _currentUser.authHeaders;
  }
  

  Future<Album> createAlbum(CreateAlbumRequest request) async {
    return http
        .post(
      'https://photoslibrary.googleapis.com/v1/albums',
      body: jsonEncode(request),
      headers: await getAuthHeaders(),
    )
        .then(
          (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }
        return Album.fromJson(jsonDecode(response.body));
      },
    );
  }
  //
  // Future<JoinSharedAlbumResponse> joinSharedAlbum(
  //     JoinSharedAlbumRequest request) async {
  //   return http
  //       .post('https://photoslibrary.googleapis.com/v1/sharedAlbums:join',
  //       headers: await getAuthHeaders(), body: jsonEncode(request))
  //       .then((Response response) {
  //     if (response.statusCode != 200) {
  //       print(response.reasonPhrase);
  //       print(response.body);
  //     }
  //
  //     return JoinSharedAlbumResponse.fromJson(jsonDecode(response.body));
  //   });
  // }
  //
  Future<ShareAlbumResponse> shareAlbum(ShareAlbumRequest request) async {
    return http
        .post(
        'https://photoslibrary.googleapis.com/v1/albums/${request.albumId}:share',
        headers: await getAuthHeaders())
        .then(
          (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        return ShareAlbumResponse.fromJson(jsonDecode(response.body));
      },
    );
  }
  //
  Future<Album> getAlbum(GetAlbumRequest request) async {
    return http
        .get(
        'https://photoslibrary.googleapis.com/v1/albums/${request.albumId}',
        headers: await getAuthHeaders())
        .then(
          (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        return Album.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<ListAlbumsResponse> listAlbums() async {
    return http
        .get(
        'https://photoslibrary.googleapis.com/v1/albums?'
            'pageSize=50',
        headers: await getAuthHeaders())
        .then(
          (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        // print(response.body);

        return ListAlbumsResponse.fromJson(jsonDecode(response.body));
      },
    );
  }
  //
  Future<ListSharedAlbumsResponse> listSharedAlbums() async {
    return http
        .get(
        'https://photoslibrary.googleapis.com/v1/sharedAlbums?'
            'pageSize=50',
        headers: await getAuthHeaders())
        .then(
          (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        print(response.body);

        return ListSharedAlbumsResponse.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<String> uploadMediaItem(File image) async {
    // Get the filename of the image
    final String filename = path.basename(image.path);
    // Set up the headers required for this request.
    final Map<String, String> headers = <String,String>{};
    headers.addAll(await getAuthHeaders());
    headers['Content-type'] = 'application/octet-stream';
    headers['X-Goog-Upload-Protocol'] = 'raw';
    headers['X-Goog-Upload-File-Name'] = filename;
    // Make the HTTP request to upload the image. The file is sent in the body.
    return http
        .post(
      'https://photoslibrary.googleapis.com/v1/uploads',
      body: image.readAsBytesSync(),
      headers: await getAuthHeaders(),
    )
        .then((Response response) {
      if (response.statusCode != 200) {
        print(response.reasonPhrase);
        print(response.body);
      }
      return response.body;
    });
  }

  Future<SearchMediaItemsResponse> searchMediaItems(
      SearchMediaItemsRequest request) async {
    return http
        .post(
      'https://photoslibrary.googleapis.com/v1/mediaItems:search',
      body: jsonEncode(request),
      headers: await getAuthHeaders(),
    )
        .then(
          (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        return SearchMediaItemsResponse.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<ListMediaItemsResponse> listMediaItems(
      ListMediaItemsRequest request) async {
    String queryParams = "";
    if (request.pageSize != null) {
      queryParams += "?pageSize=" + request.pageSize.toString();
    }
    if (request.pageToken != null) {
      queryParams += (queryParams == "") ? "?" : "&";
      queryParams += "pageToken=" + request.pageToken.toString();
    }
    String requestString = 'https://photoslibrary.googleapis.com/v1/mediaItems' + queryParams;
    Map<String, String> headers = await getAuthHeaders();
    return http
        .get(
      'https://photoslibrary.googleapis.com/v1/mediaItems' + queryParams,
      headers: await getAuthHeaders(),
    )
        .then(
          (Response response) {
            // print(response.body);
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        return ListMediaItemsResponse.fromJson(jsonDecode(response.body));
      },
    );
  }
  //
  Future<BatchCreateMediaItemsResponse> batchCreateMediaItems(
      BatchCreateMediaItemsRequest request) async {
    print(request.toJson());
    return http
        .post('https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate',
        body: jsonEncode(request), headers: await getAuthHeaders())
        .then((Response response) {
      if (response.statusCode != 200) {
        print(response.reasonPhrase);
        print(response.body);
      }

      return BatchCreateMediaItemsResponse.fromJson(jsonDecode(response.body));
    });
  }
}
