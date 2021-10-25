part of 'questions_bloc.dart';

abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object> get props => [];
}

class FetchQuestions extends QuestionsEvent {}

class AddQuestion extends QuestionsEvent {
  final String question;
  final List childConditions;

  const AddQuestion(this.question, this.childConditions);
  @override
  List<Object> get props => [question, childConditions];
}
