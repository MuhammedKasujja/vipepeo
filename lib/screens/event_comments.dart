import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/widgets/comment_textfield.dart';
import 'package:vipepeo_app/widgets/loading.dart';

class EventCommentsScreen extends StatefulWidget {
  final Event event;

  const EventCommentsScreen({Key key, @required this.event}) : super(key: key);
  @override
  _EventCommentsState createState() => _EventCommentsState();
}

class _EventCommentsState extends State<EventCommentsScreen> {
  AppState appState;
  List<EventComment> comments;
  bool isSubmitting = false;
  @override
  void initState() {
    appState = Provider.of<AppState>(context, listen: false);
    appState.eventComments(widget.event.id).then((data) {
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
          title: Text(widget.event.theme),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3),
            child: Container(
              width: double.infinity,
              child: isSubmitting ? LinearProgressIndicator() : Container(),
              color: Colors.black,
            ),
          ),
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
                            'No comments on this event',
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
          appState.makeEventComment(this.widget.event.id, val).then((value) {
            appState.eventComments(widget.event.id).then((data) {
              if (mounted)
                setState(() {
                  comments = data;
                  _showLoading(false);
                });
            });
            //_showLoading(false);
          }).catchError((onError) {
            _showLoading(false);
            AppUtils.showToast("Error sending data");
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
