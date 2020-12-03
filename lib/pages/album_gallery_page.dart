import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/photos_library_api/album.dart';
// import 'package:cabinroadphotos2/photos_library_api/media_item.dart';

class AlbumGalleryPage extends StatefulWidget {
  const AlbumGalleryPage({Key key/*, this.searchResponse*/, this.album}) : super(key: key);

  // final Future<SearchMediaItemsResponse> searchResponse;

  final Album album;

  @override
  State<StatefulWidget> createState() =>
      _AlbumGalleryPageState(/*searchResponse: searchResponse,*/ album: album);
}

class _AlbumGalleryPageState extends State<AlbumGalleryPage> {
  _AlbumGalleryPageState({/*this.searchResponse,*/ this.album});

  Album album;
  // Future<SearchMediaItemsResponse> searchResponse;
  bool _inSharingApiCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      // body: Builder(builder: (BuildContext context) {
      //   return Column(
      //     children: <Widget>[
      //       Container(
      //         width: 370,
      //         child: Text(
      //           album.title ?? '[no title]',
      //           style: TextStyle(
      //             fontSize: 36,
      //           ),
      //         ),
      //       ),
      //       _buildShareButtons(context),
      //       Container(
      //         width: 348,
      //         margin: const EdgeInsets.only(bottom: 32),
      //         child: PrimaryRaisedButton(
      //           label: const Text('ADD PHOTO'),
      //           onPressed: () => _contributePhoto(context),
      //         ),
      //       ),
      //       FutureBuilder<SearchMediaItemsResponse>(
      //         future: searchResponse,
      //         builder: _buildMediaItemList,
      //       )
      //     ],
      //   );
      // }),
    );
  }

//   Future<void> _shareAlbum(BuildContext context) async {
//     // TODO(codelab): Implement this method.
//     ToBeImplemented.showMessage();
//
//     // If the album is not shared yet, call the Library API to share it and
//     // update the local model
//
//     // Once the album contains the shareInfo data, display its share token
//   }
//
//   void _showShareableUrl(BuildContext context) {
//     // TODO(codelab): Implement this method.
//     ToBeImplemented.showMessage();
//   }
//
//   void _showShareToken(BuildContext context) {
//     // TODO(codelab): Implement this method.
//     ToBeImplemented.showMessage();
//   }
//
//   void _showTokenDialog(BuildContext context) {
//     // TODO(codelab): Implement this method.
//     ToBeImplemented.showMessage();
//   }
//
//   void _showUrlDialog(BuildContext context) {
//     // TODO(codelab): Implement this method.
//     ToBeImplemented.showMessage();
//   }
//
//   void _showShareDialog(BuildContext context, String title, String text) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(title),
//             content: Row(
//               children: [
//                 Flexible(
//                   child: Text(
//                     text,
//                   ),
//                 ),
//                 FlatButton(
//                   child: const Text('Copy'),
//                   onPressed: () => Clipboard.setData(ClipboardData(text: text)),
//                 )
//               ],
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 child: const Text('Close'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }
//
//   void _contributePhoto(BuildContext context) {
//     setState(() {
//       searchResponse = showDialog<ContributePhotoResult>(
//           context: context,
//           builder: (BuildContext context) {
//             return ContributePhotoDialog();
//           }).then((ContributePhotoResult result) {
//         return ScopedModel.of<PhotosLibraryApiModel>(context)
//             .createMediaItem(result.uploadToken, album.id, result.description);
//       }).then((BatchCreateMediaItemsResponse response) {
//         return ScopedModel.of<PhotosLibraryApiModel>(context)
//             .searchMediaItems(album.id);
//       });
//     });
//   }
//
//   Widget _buildShareButtons(BuildContext context) {
//     if (_inSharingApiCall) {
//       return const CircularProgressIndicator();
//     }
//
//     return Column(children: <Widget>[
//       Container(
//         width: 254,
//         child: FlatButton(
//           onPressed: () => _showShareableUrl(context),
//           textColor: Colors.green[800],
//           child: const Text('SHARE WITH ANYONE'),
//         ),
//       ),
//       Container(
//         width: 254,
//         child: FlatButton(
//           onPressed: () => _showShareToken(context),
//           textColor: Colors.green[800],
//           child: const Text('SHARE IN CABIN ROAD PHOTOS'),
//         ),
//       ),
//     ]);
//   }
//
//   Widget _buildMediaItemList(
//       BuildContext context, AsyncSnapshot<SearchMediaItemsResponse> snapshot) {
//     if (snapshot.hasData) {
//       if (snapshot.data.mediaItems == null) {
//         return Container();
//       }
//
//       return Expanded(
//         child: ListView.builder(
//           itemCount: snapshot.data.mediaItems.length,
//           itemBuilder: (BuildContext context, int index) {
//             return _buildMediaItem(snapshot.data.mediaItems[index]);
//           },
//         ),
//       );
//     }
//
//     if (snapshot.hasError) {
//       print(snapshot.error);
//       return Container();
//     }
//
//     return Center(
//       child: const CircularProgressIndicator(),
//     );
//   }
//
//   Widget _buildMediaItem(MediaItem mediaItem) {
//     return Column(
//       children: <Widget>[
//         Center(
//           child: CachedNetworkImage(
//             imageUrl: '${mediaItem.baseUrl}=w364',
//             progressIndicatorBuilder: (context, url, downloadProgress) =>
//                 CircularProgressIndicator(value: downloadProgress.progress),
//             errorWidget: (BuildContext context, String url, Object error) {
//               print(error);
//               return const Icon(Icons.error);
//             },
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 2),
//           width: 364,
//           child: Text(
//             mediaItem.description ?? '',
//             textAlign: TextAlign.left,
//           ),
//         ),
//       ],
//     );
//   }
}
//
// class ContributePhotoResult {
//   ContributePhotoResult(this.uploadToken, this.description);
//
//   String uploadToken;
//   String description;
// }
