import 'package:cabinroadphotos2/components/app_bar.dart';
import 'package:cabinroadphotos2/photos_library_api/search_media_items_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_view/gallery_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/photos_library_api/album.dart';
import 'package:cabinroadphotos2/photos_library_api/media_item.dart';

class AlbumGalleryPage extends StatefulWidget {
  const AlbumGalleryPage({Key key, this.searchResponse, this.album}) : super(key: key);

  final Future<SearchMediaItemsResponse> searchResponse;

  final Album album;

  @override
  State<StatefulWidget> createState() =>
      _AlbumGalleryPageState(searchResponse: searchResponse, album: album);
}

class _AlbumGalleryPageState extends State<AlbumGalleryPage> {
  _AlbumGalleryPageState({this.searchResponse, this.album});

  Album album;
  Future<SearchMediaItemsResponse> searchResponse;
  bool _inSharingApiCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PhotoAppBar(),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Text(
                album.title ?? '[no title]',
                style: TextStyle(
                  fontSize: 36,
                ),
              )
              ],
            ),
            FutureBuilder<SearchMediaItemsResponse>(
              future: searchResponse,
              builder: _buildMediaItemList,
            )
          ],
        );
      }),
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
  Widget _buildMediaItemList(BuildContext context,
      AsyncSnapshot<SearchMediaItemsResponse> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data.mediaItems == null) {
        return Container();
      }

      return Container(
          margin: EdgeInsets.all(20),
          child: CustomScrollView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ),
                  delegate: SliverChildListDelegate(
                      _buildMediaItems(snapshot.data.mediaItems)),
                )
              ]
          )
      );
    }

    if (snapshot.hasError) {
      print(snapshot.error);
      return Container();
    }

    return Center(
      child: const CircularProgressIndicator(),
    );
  }

//
  List<Widget> _buildMediaItems(List<MediaItem> mediaItems) {
    return mediaItems.map((mediaItem) =>
        Container(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Column(
                    children: <Widget>[
                      Center(
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              // width: 50,
                              // height: 50,
                              fit: BoxFit.cover,
                              imageUrl: '${mediaItem.baseUrl}=w400',
                              progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                              errorWidget: (BuildContext context, String url,
                                  Object error) {
                                print(error);
                                return const Icon(Icons.error);
                              },
                            )
                        ),
                      ),
                    ])
            )
        )
    ).toList();
  }
}

//
// class ContributePhotoResult {
//   ContributePhotoResult(this.uploadToken, this.description);
//
//   String uploadToken;
//   String description;
// }
