import 'dart:collection';

import 'package:cabinroadphotos2/components/slideshow_app_bar.dart';
import 'package:cabinroadphotos2/photos_library_api/album.dart';
import 'package:cabinroadphotos2/util/read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cabinroadphotos2/photos_library_api/media_item.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

class SlideshowPage extends StatefulWidget {
  const SlideshowPage({Key key, this.ind=0, this.albumQueue, this.isSlideshow})
      : super(key: key);

  final int ind;
  @required final DoubleLinkedQueue<MediaItem> albumQueue;
  @required final bool isSlideshow;

  @override
  State<StatefulWidget> createState() =>
      _SlideshowPageState(index: ind, albumQueue: albumQueue, isSlideshow: isSlideshow);
}

class _SlideshowPageState extends State<SlideshowPage> {
  _SlideshowPageState({this.index, this.albumQueue, this.isSlideshow});

  DoubleLinkedQueue<MediaItem> albumQueue;
  int index;
  bool showControls = false;
  bool isSlideshow;

  SwiperController _controller;

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = new SwiperController();
    super.initState();
    showControls = !isSlideshow;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controller.move(index, animation: false));
  }

  @override
  Widget build(BuildContext context) {
    // print("build: " + showControls.toString());
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
          children: <Widget>[
            Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: (showControls) ? SlideshowAppBar() : null,
              body: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return _buildImageTile(context, index);
                  // print(albumQueue.elementAt(index).baseUrl);
                  // return new Image.network(
                  //   albumQueue.elementAt(index).baseUrl,
                  //   fit: BoxFit.fitHeight,
                  // );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: true,
                autoplayDelay: (Preferences.local.getDouble("slideshowSpeed") * 1000).toInt(),
                itemCount: albumQueue.length,
                // pagination: _pagination,
                control: new SwiperControl(
                  iconPrevious: showControls ? Icons.arrow_back_ios : null,
                  iconNext: showControls ? Icons.arrow_forward_ios : null,
                ),
                controller: _controller,
                onTap: _toggleControls,
              )
            )
          ],
        ));
  }

  Widget _buildImageTile(BuildContext context, int index) {
    // print(albumQueue.elementAt(index).baseUrl);
    MediaItem mediaItem = albumQueue.elementAt(index);
    if(mediaItem.mediaMetadata.photo) {
      return new Image.network(
        albumQueue.elementAt(index).baseUrl,
        fit: BoxFit.fitHeight,
      );
    } else {
      print(albumQueue.elementAt(index).baseUrl + "=dv");
      // TODO - cache/download videos for playing
      return new VideoApp(
        controller: new VideoPlayerController.network(albumQueue.elementAt(index).baseUrl),
      );
    }

  }

  void _toggleControls(int num) {
    // print("tapped");
    setState((){
      showControls = !showControls;
    });
  }
}

class VideoApp extends StatefulWidget {
  final bool autoplay;
  @required final VideoPlayerController controller;

  const VideoApp({Key key, this.autoplay, this.controller}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState(controller: controller);
}

class _VideoAppState extends State<VideoApp> {
  _VideoAppState({this.controller});
  VideoPlayerController controller;
  bool autoplay = Preferences.local.getBool("autoplay");
  // String url;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: controller.value.initialized
              ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          backgroundColor: Colors.green[800],
          child: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,

          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}