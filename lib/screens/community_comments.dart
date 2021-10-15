import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/fancy_community_details.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/widgets/comment_textfield.dart';
import 'package:vipepeo_app/widgets/loading.dart';

class CommunityCommentsScreen extends StatefulWidget {
  final Community community;

  const CommunityCommentsScreen({Key key, @required this.community})
      : super(key: key);
  @override
  _CommunityCommentsState createState() => _CommunityCommentsState();
}

class _CommunityCommentsState extends State<CommunityCommentsScreen> {
  AppState appState;
  bool isSubmitting = false;
  var comments;
  @override
  void initState() {
    appState = Provider.of<AppState>(context, listen: false);
    appState.groupComments(widget.community.id).then((data) {
      if (mounted)
        setState(() {
          comments = data;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.community.name),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3),
            child: Container(
              width: double.infinity,
              child: isSubmitting ? LinearProgressIndicator() : Container(),
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  AppUtils(context).nextPage(
                      page: FancyCommunityDetails(
                          community: this.widget.community));
                })
          ],
        ),
        body: Container(
          child: comments != null
              ? comments.length > 0
                  ? ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var comment = comments[index];
                        return Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Text(comment.text),
                            ));
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.insert_comment,
                            color: Colors.grey[400],
                            size: 30,
                          ),
                          Text(
                            'No comments in this group',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
              : LoadingWidget(),
        ),
        bottomSheet: CommentWidget(onSendClicked: (val) {
          if (val == null || val.isEmpty) {
            AppUtils.showToast('Please write something');
            return;
          }
          _showLoading(true);
          appState.makeGroupComment(widget.community.id, val).then((value) {
            appState.groupComments(widget.community.id).then((data) {
              if (mounted)
                setState(() {
                  comments = data;
                  isSubmitting = false;
                });
            });
            // _showLoading(false);
          }).catchError((onError) {
            _showLoading(false);
          });
        }));
  }

  _showLoading(bool isLoading) {
    if (mounted)
      setState(() {
        isSubmitting = isLoading;
      });
  }
}
