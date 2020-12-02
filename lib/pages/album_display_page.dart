import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gallery_view/gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:cabinroadphotos2/components/app_bar.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

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
    // return ScopedModelDescendant<PhotosLibraryApiModel>(
    //   builder: (BuildContext context, Widget child,
    //       PhotosLibraryApiModel photosLibraryApi) {
        // if (!photosLibraryApi.hasAlbums) {
        //   return Center(
        //     child: const CircularProgressIndicator(),
        //   );
        // }

        // if (photosLibraryApi.albums.isEmpty) {
        //   return Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       SvgPicture.asset(
        //         'assets/ic_cabinroadphotos.svg',
        //         color: Colors.grey[300],
        //         height: 148,
        //       ),
        //       Container(
        //         padding: const EdgeInsets.symmetric(horizontal: 20),
        //         child: Text(
        //           "You're not currently a member of any trip albums. "
        //               'Create a new trip album or join an existing one below.',
        //           style: TextStyle(color: Colors.grey[600], fontSize: 16),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       _buildButtons(context),
        //     ],
        //   );
        // }

        return Container(
          child: Column(children: <Widget>[
            SizedBox(height: 20),
            Text("Select an Album:",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 20),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                aspectRatio: 2.5,
                viewportFraction: 0.6,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            ),
        ])
      );
  }

  final List<Widget> imageSliders = imgList.map((item) => Container(
    child: Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 800.0),
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
                  child: Text(
                    'No. ${imgList.indexOf(item)} image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    ),
  )).toList();

//   Widget _buildTripCard(BuildContext context, Album sharedAlbum,
//       PhotosLibraryApiModel photosLibraryApi) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//       ),
//       elevation: 3,
//       clipBehavior: Clip.antiAlias,
//       margin: const EdgeInsets.symmetric(
//         vertical: 12,
//         horizontal: 12,
//       ),
//       child: InkWell(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) => TripPage(
//               album: sharedAlbum,
//               searchResponse:
//               photosLibraryApi.searchMediaItems(sharedAlbum.id),
//             ),
//           ),
//         ),
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: _buildTripThumbnail(sharedAlbum),
//             ),
//             Container(
//               height: 52,
//               padding: const EdgeInsets.only(left: 8),
//               child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                 _buildSharedIcon(sharedAlbum),
//                 Align(
//                   alignment: const FractionalOffset(0, 0.5),
//                   child: Text(
//                     sharedAlbum.title ?? '[no title]',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTripThumbnail(Album sharedAlbum) {
//     if (sharedAlbum.coverPhotoBaseUrl == null ||
//         sharedAlbum.mediaItemsCount == null) {
//       return Container(
//         height: 160,
//         width: 346,
//         color: Colors.grey[200],
//         padding: const EdgeInsets.all(5),
//         child: SvgPicture.asset(
//           'assets/ic_cabinroadphotos.svg',
//           color: Colors.grey[350],
//         ),
//       );
//     }
//
//     return CachedNetworkImage(
//       imageUrl: '${sharedAlbum.coverPhotoBaseUrl}=w346-h160-c',
//       progressIndicatorBuilder: (context, url, downloadProgress) =>
//           CircularProgressIndicator(value: downloadProgress.progress),
//       errorWidget: (BuildContext context, String url, Object error) {
//         print(error);
//         return const Icon(Icons.error);
//       },
//     );
//   }
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
//   Widget _buildSharedIcon(Album album) {
//     if (album.shareInfo != null) {
//       return const Padding(
//           padding: EdgeInsets.only(right: 8),
//           child: Icon(
//             Icons.folder_shared,
//             color: Colors.black38,
//           ));
//     } else {
//       return Container();
//     }
//   }
}
