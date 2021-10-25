import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/screens/fancy_community_details.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class CommunityCommentsScreen extends StatefulWidget {
  final Community community;

  const CommunityCommentsScreen({Key key, @required this.community})
      : super(key: key);
  @override
  _CommunityCommentsState createState() => _CommunityCommentsState();
}

class _CommunityCommentsState extends State<CommunityCommentsScreen> {
  bool isSubmitting = false;
  @override
  void initState() {
    BlocProvider.of<CommentsBloc>(context)
        .add(FetchComments(widget.community.id, CommentType.group));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.community.name),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: Container(
              width: double.infinity,
              child:
                  isSubmitting ? const LinearProgressIndicator() : Container(),
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  AppUtils(context).nextPage(
                      page: FancyCommunityDetails(community: widget.community));
                })
          ],
        ),
        body:
            BlocBuilder<CommentsBloc, CommentsState>(builder: (context, state) {
          if (state.status == AppStatus.loading) {
            return const LoadingWidget();
          }
          if (state.status == AppStatus.loaded) {
            if (state.data != null && state.data.isNotEmpty) {
              return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    var comment = state.data[index];
                    return Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(comment.text),
                        ));
                  });
            }
            return Center(
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
            );
          }
          return Center(
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
          );
        }),
        bottomSheet: CommentWidget(onSendClicked: (val) {
          if (val == null || val.isEmpty) {
            AppUtils.showToast('Please write something');
            return;
          }
          BlocProvider.of<CommentsBloc>(context)
              .add(AddComment(widget.community.id, val, CommentType.group));
        }));
  }
}
