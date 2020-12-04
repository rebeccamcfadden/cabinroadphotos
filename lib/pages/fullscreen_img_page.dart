import 'dart:collection';

import 'package:cabinroadphotos2/util/read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cabinroadphotos2/photos_library_api/media_item.dart';

class FullscreenImgPage extends StatefulWidget {
  const FullscreenImgPage({Key key, this.ind, this.tag, this.album}) : super(key: key);

  final int ind;
  final String tag;
  final DoubleLinkedQueue<MediaItem> album;

  @override
  State<StatefulWidget> createState() =>
      _FullscreenImgPageState(index: ind, tag: tag, album: album);
}

class _FullscreenImgPageState extends State<FullscreenImgPage> {
  _FullscreenImgPageState({this.index, this.tag, this.album});

  DoubleLinkedQueue<MediaItem> album;
  String tag;
  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Stack(
            children: <Widget>[
              PhotoView(
                imageProvider: NetworkImage(album.elementAt(index).baseUrl),
              ),
              Positioned(
                bottom: 0.0,
                left: 15.0,
                right: 15.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Align(
                      alignment: const FractionalOffset(0, 0.5),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ReadMoreText(
                          album.elementAt(index).description ?? '',
                          trimLines: 3,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            // fontWeight: FontWeight.bold,
                          ),
                          colorClickableText: Colors.green[800],
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...Expand',
                          trimExpandedText: ' Collapse ',
                        )
                      ),
                    ),
                  ),
              ),
            ],
          )
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: PhotoAppBar(),
    //   body: Builder(builder: (BuildContext context) {
    //     return ListView(
    //       // crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         SizedBox(height: 20),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[Text(
    //             album.title ?? '[no title]',
    //             style: TextStyle(
    //               fontSize: 36,
    //             ),
    //           )
    //           ],
    //         ),
    //         FutureBuilder<SearchMediaItemsResponse>(
    //           future: searchResponse,
    //           builder: _buildMediaItemList,
    //         )
    //       ],
    //     );
    //   }),
    // );
  }

//   Widget _buildMediaItemList(BuildContext context,
//       AsyncSnapshot<SearchMediaItemsResponse> snapshot) {
//     if (snapshot.hasData) {
//       if (snapshot.data.mediaItems == null) {
//         return Container();
//       }
//
//       return Container(
//           margin: EdgeInsets.all(20),
//           child: CustomScrollView(
//               shrinkWrap: true,
//               physics: ScrollPhysics(),
//               slivers: <Widget>[
//                 SliverGrid(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 7,
//                       childAspectRatio: 1,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10
//                   ),
//                   delegate: SliverChildListDelegate(
//                       _buildMediaItems(snapshot.data.mediaItems)),
//                 )
//               ]
//           )
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
// //
//   List<Widget> _buildMediaItems(List<MediaItem> mediaItems) {
//     return mediaItems.asMap().entries.map((entry) {
//       int idx = entry.key;
//       MediaItem mediaItem = entry.value;
//       return Container(
//           child: InkWell(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => AlbumGalleryPage(
//                     album: sharedAlbum,
//                     searchResponse:
//                     photosLibraryApi.searchMediaItems(sharedAlbum.id),
//                   ),
//                 ),
//               ),
//               child: ClipRRect(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   child: Column(
//                       children: <Widget>[
//                         Center(
//                           child: AspectRatio(
//                               aspectRatio: 1,
//                               child: CachedNetworkImage(
//                                 // width: 50,
//                                 // height: 50,
//                                 fit: BoxFit.cover,
//                                 imageUrl: '${mediaItem.baseUrl}=w400',
//                                 progressIndicatorBuilder: (context, url,
//                                     downloadProgress) =>
//                                     CircularProgressIndicator(
//                                         value: downloadProgress.progress),
//                                 errorWidget: (BuildContext context, String url,
//                                     Object error) {
//                                   print(error);
//                                   return const Icon(Icons.error);
//                                 },
//                               )
//                           ),
//                         ),
//                       ])
//               )
//           )
//       );
//     }
//     ).toList();
//   }
}