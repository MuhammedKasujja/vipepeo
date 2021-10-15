import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/widgets/community_item.dart';
import 'package:vipepeo_app/widgets/community_shimmer.dart';

class CommunityListWidget extends StatefulWidget {
  const CommunityListWidget({Key key}) : super(key: key);

  @override
  _CommunityListState createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityListWidget> {
  PageController _pageController;
  AppState appState;
  final double _imageHeight = 200.0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    return Container(
        // color: Colors.grey[300],
        height: _imageHeight,
        child: appState.communities == null
            ? FutureBuilder(
                future: appState.getMyGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Shimmer.fromColors(
                              child: CommunityShimmer(),
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.white);
                        });
                    // return Center(
                    //     child: Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: LoadingWidget(),
                    // ));
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Container(
                              height: 30, width: 50, child: Text("Try again")),
                          onTap: () {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  }
                  return groupList(snapshot.data);
                },
              )
            : groupList(appState.communities));
  }

  Widget groupList(List data) {
    return ListView(
      children: <Widget>[
        Container(
          height: _imageHeight,
          width: double.infinity,
          child: PageView.builder(
              controller: _pageController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                // return _groupSelector(index);
                return CommunityItemWidget(
                  community: data[index],
                );
              }),
        )
      ],
    );
  }

  Widget groupSelector(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.6).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 270.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0)
                  ]),
              child: Center(
                child: Hero(
                    tag: appState.communities[index].image,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: appState.communities[index].image,
                        height: 220.0,
                        fit: BoxFit.fill,
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
