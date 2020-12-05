import 'dart:collection';

import 'package:cabinroadphotos2/photos_library_api/album.dart';
import 'package:cabinroadphotos2/util/read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cabinroadphotos2/photos_library_api/media_item.dart';

class SlideshowPage extends StatefulWidget {
  const SlideshowPage({Key key, this.ind, this.album, this.albumQueue})
      : super(key: key);

  final int ind;
  final Album album;
  final DoubleLinkedQueue<MediaItem> albumQueue;

  @override
  State<StatefulWidget> createState() =>
      _SlideshowPageState(index: ind, album: album, albumQueue: albumQueue);
}

class _SlideshowPageState extends State<SlideshowPage> {
  _SlideshowPageState({this.index, this.album, this.albumQueue});

  DoubleLinkedQueue<MediaItem> albumQueue;
  Album album;
  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: new AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    albumQueue.elementAt(index).baseUrl,
                    fit: BoxFit.fitHeight,
                  );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: true,
                autoplayDelay: 70000,
                itemCount: albumQueue.length,
                pagination: new SwiperPagination(),
                control: new SwiperControl(),
              ),
              // body: GestureDetector(
              //   child: Center(
              //       child: Stack(
              //         children: <Widget>[
              //           PhotoView(
              //             imageProvider: NetworkImage(albumQueue
              //                 .elementAt(index)
              //                 .baseUrl),
              //           ),
              //           Positioned(
              //             bottom: 0.0,
              //             left: 15.0,
              //             right: 15.0,
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 gradient: LinearGradient(
              //                   colors: [
              //                     Color.fromARGB(200, 0, 0, 0),
              //                     Color.fromARGB(0, 0, 0, 0)
              //                   ],
              //                   begin: Alignment.bottomCenter,
              //                   end: Alignment.topCenter,
              //                 ),
              //               ),
              //               padding: EdgeInsets.symmetric(
              //                   vertical: 10.0, horizontal: 20.0),
              //               child: Align(
              //                 alignment: const FractionalOffset(0, 0.5),
              //                 child: Container(
              //                     width: MediaQuery
              //                         .of(context)
              //                         .size
              //                         .width,
              //                     child: ReadMoreText(
              //                       albumQueue
              //                           .elementAt(index)
              //                           .description ?? '',
              //                       trimLines: 3,
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 20.0,
              //                         // fontWeight: FontWeight.bold,
              //                       ),
              //                       colorClickableText: Colors.green[800],
              //                       trimMode: TrimMode.Line,
              //                       trimCollapsedText: '...Expand',
              //                       trimExpandedText: ' Collapse ',
              //                     )
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       )
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // ),
            )
          ],
        ));
  }
}
