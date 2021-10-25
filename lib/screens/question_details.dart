import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QuestionDetailsScreen extends StatefulWidget {
  final Question question;
  final Function(Question question) onReply;

  const QuestionDetailsScreen({Key key, @required this.question, this.onReply})
      : super(key: key);
  @override
  _QuestionDetailsScreenState createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen> {
  final _controller = TextEditingController();

  int totalAnswers;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    totalAnswers = widget.question.totalAnswers;
    BlocProvider.of<QuestionAnswersBloc>(context)
        .add(FetchQuestionAnswers(widget.question.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Details'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: BlocBuilder<QuestionAnswersBloc, QuestionAnswersState>(
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '${widget.question.question} ?',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: <Widget>[
                  const Text('Replies'),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text('$totalAnswers'),
                  ),
                ],
              ),
            ),
            const Divider(),
            BlocBuilder<QuestionAnswersBloc, QuestionAnswersState>(
              builder: (context, state) {
                if (state.data != null) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.data.length,
                    // physics: NeverScrollingPhysics(),
                    itemBuilder: (context, index) {
                      var answer = state.data[index];
                      return ListTile(
                        key: Key('${answer.id}'),
                        subtitle: Text(answer.answeredBy),
                        title: Text(answer.text),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    answer.userPhoto),
                                fit: BoxFit.cover,
                                // colorFilter: ColorFilter.mode(
                                //     AppTheme.PrimaryAssentColor, BlendMode.colorBurn)
                              )),
                        ),
                        trailing: BlocListener<QuestionAnswersBloc,
                            QuestionAnswersState>(
                          listener: (context, state) {
                            if (state.status == AppStatus.loaded) {
                              if (state.message == "approved") {
                                setState(() {
                                  answer.approvals++;
                                });
                              } else {
                                setState(() {
                                  answer.approvals--;
                                });
                              }
                            }
                            if (state.status == AppStatus.failure) {
                              AppUtils.showToast(state.error);
                            }
                          },
                          child: InkWell(
                            child: Column(
                              children: [
                                Container(
                                    decoration:
                                        BoxDecoration(color: Colors.green[100]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 6.0),
                                      child: Text('${answer.approvals}'),
                                    )),
                                const SizedBox(
                                  height: 2,
                                ),
                                const Text.rich(
                                  TextSpan(
                                      text: 'Approve',
                                      // recognizer: new TapGestureRecognizer()
                                      //   ..onTap = () {},
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          letterSpacing: 1.5,
                                          color: Colors.blue)),
                                )
                              ],
                            ),
                            onTap: () {
                              BlocProvider.of<QuestionAnswersBloc>(context)
                                  .add(ApproveAnswer(answer.id));
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                if (state.status == AppStatus.loading) {
                  const LoadingWidget();
                }
                return Container();
              },
            )
          ],
        ),
      ),
      // floatingActionButton: BottomSheet(),
      bottomSheet: BlocListener<QuestionAnswersBloc, QuestionAnswersState>(
        listener: (context, state) {
          if (state.status == AppStatus.loading) {
            _showLoading(true);
          }
          if (state.status == AppStatus.loaded && isSubmitting) {
            if (state.success) {
              setState(() {
                totalAnswers++;
              });
              BlocProvider.of<QuestionAnswersBloc>(context)
                  .add(FetchQuestionAnswers(widget.question.id));
            }
          }
          if (state.status == AppStatus.failure) {
            AppUtils.showToast(state.error);
          }
          _showLoading(false);
        },
        child: CommentWidget(
          onSendClicked: (val) {
            BlocProvider.of<QuestionAnswersBloc>(context)
                .add(AnswerQuestion(widget.question.id, val));
          },
        ),
      ),
      // FloatingActionButton.extended(
      //   onPressed: () {
      //     Scaffold.of(context).showBottomSheet<void>((context) {
      //       return Container(
      //         child: Column(
      //           children: <Widget>[
      //             TextfieldControllerWidget(
      //                 hint: 'Type someting', controller: _controller)
      //           ],
      //         ),
      //       );
      //     });
      //   },
      //   label: Text('Reply'),
      //   icon: Icon(Icons.add),
      // )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        isSubmitting = isLoading;
      });
    }
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Scaffold.of(context).showBottomSheet<void>((context) {
          return Container(
            decoration: const BoxDecoration(
              color: AppTheme.PrimaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            ),
            height: 100,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: TextfieldControllerWidget(
                        hint: 'Type someting', controller: null),
                  ),
                ),
              ],
            ),
          );
        });
      },
      label: const Text('Reply'),
      icon: const Icon(Icons.add),
    );
  }
}
