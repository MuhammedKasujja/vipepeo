import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'question_answers_event.dart';
part 'question_answers_state.dart';

class QuestionAnswersBloc
    extends Bloc<QuestionAnswersEvent, QuestionAnswersState> {
  final _repo = Repository();
  QuestionAnswersBloc()
      : super(const QuestionAnswersState(
          status: AppStatus.init,
          success: false,
        )) {
    on<FetchQuestionAnswers>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.fetchQuestionAnswers(event.questionId);
        emit(state.loaded(data: data));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AnswerQuestion>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.answerQuestion(
            answer: event.answer, questioID: event.questionId);
        emit(state.loaded(
          message: res.message,
          success: res.success,
        ));
        add(FetchQuestionAnswers(event.questionId));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
  }
}
