import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/view_full_image.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/screens/add_edit_community.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class FancyCommunityDetails extends StatefulWidget {
  final Community community;

  const FancyCommunityDetails({Key key, this.community}) : super(key: key);

  @override
  _FancyCommunityDetailsState createState() => _FancyCommunityDetailsState();
}

class _FancyCommunityDetailsState extends State<FancyCommunityDetails> {
  bool isSubmitting = false;
  File updatedImage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            color: Colors.grey[400],
          ),
          InkWell(
            child: Hero(
              tag: widget.community.image,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: updatedImage == null
                            ? CachedNetworkImageProvider(widget.community.image)
                            : FileImage(updatedImage))),
              ),
            ),
            onTap: () {
              AppUtils(context).nextPage(
                  page: ViewFullImageScreen(imageUrl: widget.community.image));
            },
          ),
          Positioned(
            top: 280,
            left: 10,
            right: 10,
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height - 280,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.community.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.PrimaryColor,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    state.data.email ==
                                            widget.community.createdBy
                                        ? IconButton(
                                            onPressed: () {
                                              AppUtils(context).nextPage(
                                                  page: AddCommunityScreen(
                                                      community:
                                                          widget.community,
                                                      updateCommunity:
                                                          _updatedCommunity));
                                            },
                                            tooltip: 'Edit Community',
                                            icon: const Icon(
                                              Icons.edit,
                                              color: AppTheme.PrimaryColor,
                                            ),
                                          )
                                        : BlocListener<GroupsBloc, GroupsState>(
                                            listener: (context, state) {
                                              if (state.status ==
                                                  AppStatus.loaded) {
                                                setState(() {
                                                  widget.community.isMember =
                                                      !widget
                                                          .community.isMember;
                                                });
                                              }
                                              if (!state.success) {
                                                AppUtils.showToast(
                                                    state.message);
                                              }
                                              if (state.status ==
                                                  AppStatus.failure) {
                                                AppUtils.showToast(state.error);
                                              }
                                            },
                                            child: Stack(
                                              children: <Widget>[
                                                OutlineButton(
                                                  borderSide: const BorderSide(
                                                    color:
                                                        AppTheme.PrimaryColor,
                                                    width: 2,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: Text(
                                                    widget.community.isMember
                                                        ? 'Joined'
                                                        : 'Join',
                                                    style: const TextStyle(
                                                        color: AppTheme
                                                            .PrimaryColor),
                                                  ),
                                                  onPressed: () {
                                                    BlocProvider.of<GroupsBloc>(
                                                            context)
                                                        .add(
                                                            JoinOrLeaveCommunity(
                                                                widget.community
                                                                    .id));
                                                  },
                                                ),
                                                state.status ==
                                                        AppStatus.loading
                                                    ? const CircularProgressWidget()
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Text('${widget.community.country},'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          widget.community.locDistrict ??
                                              "City"),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Description',
                                      style: TextStyle(fontSize: 16)),
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
                                state.data.email != widget.community.createdBy
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                "Created By",
                                              ),
                                            ),
                                            Text(widget.community.createdBy,
                                                style: const TextStyle(
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ),
          ),
          const BackIcon(),
        ],
      ),
    );
  }

  Widget groupTopics() {
    List<Widget> topics = [];
    final childConditionsBloc = BlocProvider.of<ChildConditionsBloc>(context);
    for (int i in List<int>.from(widget.community.topics)) {
      for (var condition in childConditionsBloc.state.data) {
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

  void _showLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        isSubmitting = isLoading;
      });
    }
  }
}
