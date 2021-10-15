import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class ViewFullImageScreen extends StatelessWidget {
  final String imageUrl;
  final int imageType; //0 network : 1 asset  {Image}

  const ViewFullImageScreen(
      {Key key, @required this.imageUrl, this.imageType = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: AppTheme.PrimaryDarkColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Hero(
                      tag: this.imageUrl,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: this.imageType == 0
                                    ? CachedNetworkImageProvider(this.imageUrl)
                                    : AssetImage(this.imageUrl))),
                      )),
                ),
                Positioned(
                  top: 8,
                  left: 10,
                  child: InkWell(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          //color: Colors.black.withOpacity(.2),
                          color: AppTheme.PrimaryDarkColor,
                          borderRadius: BorderRadius.circular(35)),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
