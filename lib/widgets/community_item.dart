import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vipepeo_app/models/community.dart';
import 'package:vipepeo_app/screens/community_comments.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommunityItemWidget extends StatelessWidget {
  final double height;
  final Community community;

  const CommunityItemWidget({Key key, this.height, @required this.community})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          children: <Widget>[
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.black54],
                ).createShader(bounds);
              },
              child: Container(
                width: double.infinity,
                height: height ?? 200,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(community.image),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Positioned(
                left: 0.0,
                bottom: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    community.name,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ))

            // Container(
            //   height: this.height == null ? 200 : this.height,
            //   // width: 240,
            //   decoration: BoxDecoration(
            //       color: AppTheme.PrimaryDarkColor,
            //       borderRadius: BorderRadius.all(Radius.circular(20.0)),
            //       image: DecorationImage(
            //         image: CachedNetworkImageProvider(this.community.image),
            //         fit: BoxFit.cover,
            //         // colorFilter: ColorFilter.mode(
            //         //     AppTheme.PrimaryAssentColor, BlendMode.colorBurn)
            //       )
            //       //shape:
            //       ),
            //   // child: CachedNetworkImage(
            //   //   imageUrl: this.community.image,
            //   //   fit: BoxFit.fill,
            //   // ),
            // ),
            // Positioned(
            //     bottom: 0.0,
            //     left: 0.0,
            //     right: 0.0,
            //     child: Container(
            //       decoration: BoxDecoration(
            //           color: Colors.black.withOpacity(0.1),
            //           borderRadius: BorderRadius.only(
            //               bottomLeft: Radius.circular(20.0),
            //               bottomRight: Radius.circular(20.0)),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.black.withOpacity(0.1),
            //                   blurRadius: 6
            //                 )
            //               ]),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           community.name,
            //           style: TextStyle(
            //               color: Colors.white,
            //               letterSpacing: 1,
            //               fontSize: 20),
            //         ),
            //       ),
            //     ))
          ],
        ),
      ),
      onTap: () {
        AppUtils(context)
            .nextPage(page: CommunityCommentsScreen(community: community));
      },
    );
  }
}
