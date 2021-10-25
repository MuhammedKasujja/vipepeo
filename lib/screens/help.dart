import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/widgets/event_loading.dart';
import 'add_edit_question.dart';
import 'question_details.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Future<List<Question>> futureQuestions;

  @override
  void initState() {
    final _questionsBloc = BlocProvider.of<QuestionsBloc>(context);
    // if (_questionsBloc.state.data == null) {
    _questionsBloc.add(FetchQuestions());
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          BlocBuilder<QuestionsBloc, QuestionsState>(builder: (context, state) {
        if (state.data != null) {
          return _buildQuestionList(state.data);
        }
        if (state.status == AppStatus.loading) {
          return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                    child: const EventLoadingWidget(
                      size: 60,
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white);
              });
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
                  BlocProvider.of<QuestionsBloc>(context).add(FetchQuestions());
                },
              ),
            ),
          );
        }

        return const Text('No Data found');
      }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.PrimaryColor,
          onPressed: () {
            AppUtils(context).nextPage(page: const AddEditQuestionScreen());
          },
          child: const Text(
            '?',
            style: TextStyle(fontSize: 25),
          ) //Icon(Icons.add),
          ),
    );
  }

  Widget _buildQuestionList(List<Question> questions) {
    return ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          var quest = questions[index];
          return InkWell(
            splashColor: Colors.grey[400],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // Chip(label: Text('Q')),
                                  Text(
                                    quest.question,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Chip(
                                  backgroundColor: AppTheme.PrimaryColor,
                                  avatar: Text('${quest.totalAnswers}'),
                                  label: const Text(
                                    'Replies',
                                    style: TextStyle(fontSize: 10),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(quest.postedBy),
                              Text(
                                quest.postedOn,
                                style: const TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.black54,
                      thickness: 0.2,
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              AppUtils(context).nextPage(
                  page: QuestionDetailsScreen(
                question: quest,
                onReply: (
                  quest,
                ) {
                  setState(() {
                    quest.totalAnswers++;
                  });
                },
              ));
            },
          );
        });
  }
}
