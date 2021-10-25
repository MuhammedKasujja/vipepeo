import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
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
  @override
  void initState() {
    BlocProvider.of<CommentsBloc>(context)
        .add(FetchComments(widget.event.id, CommentType.event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.event.theme),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: BlocBuilder<CommentsBloc, CommentsState>(
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
        ),
        body: BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            return Container(
              child: state.data != null
                  ? state.data.isNotEmpty
                      ? ListView.builder(
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
                  : const LoadingWidget(),
            );
          },
        ),
        bottomSheet: CommentWidget(onSendClicked: (val) {
          if (val == null || val.isEmpty) {
            AppUtils.showToast('Please write something');
            return;
          }
          BlocProvider.of<CommentsBloc>(context)
              .add(AddComment(widget.event.id, val, CommentType.event));
        }));
  }
}
