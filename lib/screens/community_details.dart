import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/view_full_image.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/screens/add_edit_community.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final Community community;

  const CommunityDetailsScreen({Key key, @required this.community})
      : super(key: key);

  @override
  _CommunityDetailsScreenState createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  bool isSubmitting = false;
  File updatedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Details"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: BlocBuilder<GroupsBloc, GroupsState>(
              builder: (context, state) {
                return Container(
                  width: double.infinity,
                  child: state.status == AppStatus.loading
                      ? const LinearProgressIndicator()
                      : Container(),
                  color: Colors.black,
                );
              },
            ),
          ),
          // actions: <Widget>[
          //   widget.community.createdBy == _appState.user.email
          //       ? IconButton(
          //           icon: Icon(Icons.edit),
          //           onPressed: () {
          //             AppUtils(context).nextPage(
          //                 page: AddCommunityScreen(
          //               community: widget.community,
          //             ));
          //           },
          //         )
          //       : InkWell(
          //           child: Padding(
          //             padding: const EdgeInsets.only(top: 12, right: 10),
          //             child: Container(
          //                 child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Text(hasJoined ? 'Leave' : 'Join'),
          //             )),
          //           ),
          //           onTap: _joinLeaveGroup,
          //         )
          // ],
        ),
        body: ListView(
          children: <Widget>[
            InkWell(
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Hero(
                    tag: widget.community.image,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: updatedImage == null
                                  ? CachedNetworkImageProvider(
                                      widget.community.image)
                                  : FileImage(updatedImage))),
                    ),
                  ),
                ],
              ),
              onTap: () {
                AppUtils(context).nextPage(
                    page:
                        ViewFullImageScreen(imageUrl: widget.community.image));
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: const BoxDecoration(
                        // color: Colors.grey[300],
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(30),
                        //     topRight: Radius.circular(30))
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.community.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${widget.community.country},'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.community.locDistrict ?? "City"),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Description', style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.community.description,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Topics'),
                  ),
                  groupTopics(),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state.data.email != widget.community.createdBy) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Created By",
                                ),
                              ),
                              Text(widget.community.createdBy,
                                  style: const TextStyle(color: Colors.grey))
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.data.email == widget.community.createdBy) {
              return FloatingActionButton(
                  onPressed: () {
                    AppUtils(context).nextPage(
                        page: AddCommunityScreen(
                            community: widget.community,
                            updateCommunity: _updatedCommunity));
                  },
                  tooltip: 'Edit Community',
                  child: const Icon(Icons.edit),
                  backgroundColor: AppTheme.PrimaryColor);
            }
            return FloatingActionButton.extended(
              onPressed: _joinLeaveGroup,
              label: Text(widget.community.isMember ? 'Leave' : 'Join'),
              tooltip: 'Join Community',
              icon: Icon(widget.community.isMember ? Icons.clear : Icons.add),
              backgroundColor: AppTheme.PrimaryColor,
            );
          },
        )
        // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        );
  }

  _joinLeaveGroup() {
    BlocProvider.of<GroupsBloc>(context)
        .add(JoinOrLeaveCommunity(widget.community.id));

    setState(() {
      widget.community.isMember = !widget.community.isMember;
    });
  }

  Widget groupTopics() {
    List<Widget> topics = [];
    final childConditionsState =
        BlocProvider.of<ChildConditionsBloc>(context).state;
    for (int i in List<int>.from(widget.community.topics)) {
      for (var condition in childConditionsState.data) {
        if (condition.id == i) {
          topics.add(Padding(
            padding: const EdgeInsets.all(2.0),
            child: Chip(
              label: Text(
                condition.name,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppTheme.PrimaryDarkColor,
            ),
          ));
        }
      }
    }
    return Wrap(
      children: topics,
    );
  }

  _updatedCommunity(Community community) {
    setState(() {
      widget.community.description = community.description;
      widget.community.name = community.name;
      widget.community.locDistrict = community.locDistrict;
      widget.community.country = community.country;
      widget.community.topics = community.topics;
      // widget.community.image = community.image;
      updatedImage = File(community.image);
    });
  }
}
