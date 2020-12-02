import 'package:flutter/material.dart';
import 'package:cabinroadphotos2/components/app_bar.dart';
import 'package:cabinroadphotos2/model/photos_library_api_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';

import 'album_display_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PhotoAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder:
          (BuildContext context, Widget child, PhotosLibraryApiModel apiModel) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/lockup_photos_horizontal.svg',
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: const Text(
                'Get albums to display in Cabin Road Photos',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Color(0x99000000)),
              ),
            ),
            RaisedButton(
              padding: const EdgeInsets.all(15),
              child: const Text('Connect with Google Photos'),
              onPressed: () async {
                try {
                  await apiModel.signIn()
                      ? _navigateToTripList(context)
                      : _showSignInError(context);
                } on Exception catch (error) {
                  print(error);
                  _showSignInError(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSignInError(BuildContext context) {
    final SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: const Text('Could not sign in.\n'
          'Is the Google Services file missing?'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _navigateToTripList(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AlbumDisplayPage(),
      ),
    );
  }
}
