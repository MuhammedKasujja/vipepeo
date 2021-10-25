part of 'question_answers_bloc.dart';

abstract class QuestionAnswersEvent extends Equatable {
  const QuestionAnswersEvent();

  @override
  List<Object> get props => [];
}

class FetchQuestionAnswers extends QuestionAnswersEvent {
  final dynamic questionId;

  const FetchQuestionAnswers(this.questionId);

  @override
  List<Object> get props => [questionId];
}

class AnswerQuestion extends QuestionAnswersEvent {
  final dynamic questionId;
  final String answer;

  const AnswerQuestion(this.questionId, this.answer);
  @override
  List<Object> get props => [questionId, answer];
}

class ApproveAnswer extends QuestionAnswersEvent {
  final dynamic answerId;

  const ApproveAnswer(this.answerId);
  @override
  List<Object> get props => [answerId];
}
