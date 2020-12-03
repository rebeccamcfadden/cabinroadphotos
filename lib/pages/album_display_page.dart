import 'package:cabinroadphotos2/photos_library_api/album.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gallery_view/gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/components/app_bar.dart';

import 'album_gallery_page.dart';

class AlbumDisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PhotoAppBar(),
      body: _viewAlbums(context),
    );
  }

  Widget _viewAlbums(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget child,
          PhotosLibraryApiModel photosLibraryApi)
    {
      if (!photosLibraryApi.hasAlbums) {
        return Center(
          child: const CircularProgressIndicator(),
        );
      }

      if (photosLibraryApi.albums.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SvgPicture.asset(
              'assets/ic_cabinrdphoto.svg',
              color: Colors.grey[300],
              height: 148,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "You don't have any albums to display. "
                    'Create a new album or join an existing one in Google Photos.',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            // _buildButtons(context),
          ],
        );
      }

      return Container(
          child: Column(children: <Widget>[
            SizedBox(height: 20),
            Text("Select an Album:",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
            SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: photosLibraryApi.albums.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildAlbumSliders(context, photosLibraryApi.albums[index], photosLibraryApi);
              },
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 20),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                aspectRatio: 2.5,
                viewportFraction: 0.6,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            ),
          ])
      );
    });
  }

  Widget _buildAlbumSliders(BuildContext context, Album sharedAlbum,
  PhotosLibraryApiModel photosLibraryApi) {
    return Container(
        child: InkWell(
          onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AlbumGalleryPage(
              album: sharedAlbum,
              searchResponse:
              photosLibraryApi.searchMediaItems(sharedAlbum.id),
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: _buildTripThumbnail(sharedAlbum, BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
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
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      _buildSharedIcon(sharedAlbum),
                      Align(
                        alignment: const FractionalOffset(0, 0.5),
                        child: Text(
                          sharedAlbum.title ?? '[no title]',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  Widget _buildTripThumbnail(Album sharedAlbum, BoxFit bfit) {
    if (sharedAlbum.coverPhotoBaseUrl == null ||
        sharedAlbum.mediaItemsCount == null) {
      return Container(
        height: 320,
        width: 800,
        color: Colors.grey[200],
        padding: const EdgeInsets.all(5),
        child: SvgPicture.asset(
          'assets/ic_cabinrdphoto.svg',
          color: Colors.grey[350],
        ),
      );
    }

    return CachedNetworkImage(
      fit: bfit,
      imageUrl: '${sharedAlbum.coverPhotoBaseUrl}=w800-h600-c',
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (BuildContext context, String url, Object error) {
        print(error);
        return const Icon(Icons.error);
      },
    );
  }
//
//   Widget _buildButtons(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           PrimaryRaisedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => CreateTripPage(),
//                 ),
//               );
//             },
//             label: const Text('CREATE A TRIP ALBUM'),
//           ),
//           Container(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               ' - or - ',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           FlatButton(
//             textColor: Colors.green[800],
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => JoinTripPage(),
//                 ),
//               );
//             },
//             child: const Text('JOIN A TRIP ALBUM'),
//           ),
//         ],
//       ),
//     );
//   }
//
  Widget _buildSharedIcon(Album album) {
    print("Share info for " + album.title + " is " + album.shareInfo.toString());
    if (album.shareInfo != null) {
      return const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.folder_shared,
            color: Colors.black38,
          ));
    } else {
      return Container();
    }
  }
}
