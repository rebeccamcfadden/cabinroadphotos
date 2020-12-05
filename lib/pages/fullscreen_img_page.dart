import 'dart:collection';

import 'package:cabinroadphotos2/photos_library_api/album.dart';
import 'package:cabinroadphotos2/util/read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cabinroadphotos2/photos_library_api/media_item.dart';

class FullscreenImgPage extends StatefulWidget {
  const FullscreenImgPage({Key key, this.ind, this.albumQueue})
      : super(key: key);

  final int ind;
  final DoubleLinkedQueue<MediaItem> albumQueue;

  @override
  State<StatefulWidget> createState() =>
      _FullscreenImgPageState(index: ind, albumQueue: albumQueue);
}

class _FullscreenImgPageState extends State<FullscreenImgPage> {
  _FullscreenImgPageState({this.index, this.albumQueue});

  DoubleLinkedQueue<MediaItem> albumQueue;
  SwiperController _controller;
  int index;

  @override
  void initState() {
    _controller = new SwiperController();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controller.move(index, animation: false));
  }

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
                itemCount: albumQueue.length,
                pagination: new SwiperPagination(),
                control: new SwiperControl(),
                controller: _controller,
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
