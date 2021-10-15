import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/view_full_image.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/screens/add_edit_community.dart';
import 'package:vipepeo_app/widgets/circular_progress_widget.dart';
import 'package:vipepeo_app/widgets/back_icon.dart';

class FancyCommunityDetails extends StatefulWidget {
  final Community community;

  const FancyCommunityDetails({Key key, this.community}) : super(key: key);

  @override
  _FancyCommunityDetailsState createState() => _FancyCommunityDetailsState();
}

class _FancyCommunityDetailsState extends State<FancyCommunityDetails> {
  bool isSubmitting = false;
  AppState _appState;
  File updatedImage;
  @override
  void initState() {
    _appState = Provider.of<AppState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              color: Colors.grey[400],
            ),
            InkWell(
              child: Hero(
                tag: this.widget.community.image,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: updatedImage == null
                              ? CachedNetworkImageProvider(
                                  this.widget.community.image)
                              : FileImage(updatedImage))),
                ),
              ),
              onTap: () {
                AppUtils(context).nextPage(
                    page: ViewFullImageScreen(
                        imageUrl: this.widget.community.image));
              },
            ),
            Positioned(
              top: 280,
              left: 10,
              right: 10,
              child: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height - 280,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
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
                                        '${this.widget.community.name}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.PrimaryColor,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  _appState.user.email ==
                                          widget.community.createdBy
                                      ? IconButton(
                                          onPressed: () {
                                            AppUtils(context).nextPage(
                                                page: AddCommunityScreen(
                                                    community: widget.community,
                                                    updateCommunity:
                                                        _updatedCommunity));
                                          },
                                          tooltip: 'Edit Community',
                                          icon: Icon(
                                            Icons.edit,
                                            color: AppTheme.PrimaryColor,
                                          ),
                                        )
                                      : Stack(
                                          children: <Widget>[
                                            OutlineButton(
                                              borderSide: BorderSide(
                                                color: AppTheme.PrimaryColor,
                                                width: 2,
                                              ),
                                              padding: EdgeInsets.all(2),
                                              child: Text(
                                                widget.community.isMember
                                                    ? 'Joined'
                                                    : 'Join',
                                                style: TextStyle(
                                                    color:
                                                        AppTheme.PrimaryColor),
                                              ),
                                              onPressed: _joinLeaveGroup,
                                            ),
                                            isSubmitting
                                                ? CircularProgressWidget()
                                                : Container()
                                          ],
                                        ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '${this.widget.community.country},'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        this.widget.community.locDistrict ??
                                            "City"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Description',
                                    style: TextStyle(fontSize: 16)),
                              ),
                              Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${this.widget.community.description}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Topics'),
                              ),
                              groupTopics(),
                              _appState.user.email != widget.community.createdBy
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "Created By",
                                            ),
                                          ),
                                          Text('${widget.community.createdBy}',
                                              style:
                                                  TextStyle(color: Colors.grey))
                                        ],
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            BackIcon(),
          ],
        ),
      ),
    );
  }

  _joinLeaveGroup() {
    _showLoading(true);
    Provider.of<AppState>(context, listen: false)
        .joinOrLeaveGroup(
      widget.community.id,
    )
        .then((value) {
      print(value);
      setState(() {
        widget.community.isMember = !widget.community.isMember;
      });
      _showLoading(false);
    }).catchError((onError) {
      _showLoading(false);
      AppUtils.showToast('Something went wrong');
    });
  }

  Widget groupTopics() {
    List<Widget> topics = [];
    for (int i in List<int>.from(widget.community.topics)) {
      for (var condition in _appState.childConditions) {
        if (condition.id == i) {
          topics.add(Padding(
            padding: const EdgeInsets.all(2.0),
            child: Chip(
              label: Text(
                condition.name,
                style: TextStyle(color: Colors.white),
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
    if (mounted)
      setState(() {
        isSubmitting = isLoading;
      });
  }
}
