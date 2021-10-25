import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vipepeo_app/blocs/groups/groups_bloc.dart';
import 'package:vipepeo_app/models/enums.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class CommunityListWidget extends StatefulWidget {
  const CommunityListWidget({Key key}) : super(key: key);

  @override
  _CommunityListState createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityListWidget> {
  PageController _pageController;

  final double _imageHeight = 200.0;
  @override
  void initState() {
    BlocProvider.of<GroupsBloc>(context);
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state.status == AppStatus.loading) {
          return SizedBox(
            height: _imageHeight,
            child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return Shimmer.fromColors(
                      child: const CommunityShimmer(),
                      baseColor: Colors.grey[400],
                      highlightColor: Colors.white);
                }),
          );
        }
        if (state.status == AppStatus.failure) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                child: const SizedBox(
                    height: 30, width: 50, child: Text("Try again")),
                onTap: () {
                  setState(() {});
                },
              ),
            ),
          );
        }
        if (state.data != null) {
          return groupList(state.data);
        }
        return const Center(child: Text('No data found'));
      },
    );
  }

  Widget groupList(List data) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: _imageHeight,
          width: double.infinity,
          child: PageView.builder(
              controller: _pageController,
              itemCount: data?.length,
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
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
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
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0)
                      ]),
                  child: Center(
                    child: Hero(
                        tag: state.data[index].image,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: state.data[index].image,
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
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
