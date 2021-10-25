part of 'question_answers_bloc.dart';

class QuestionAnswersState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<Answer> data;
  final bool success;

  const QuestionAnswersState(
      {this.error, this.message, this.status, this.data, this.success});

  QuestionAnswersState init() {
    return const QuestionAnswersState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  QuestionAnswersState load() {
    return QuestionAnswersState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  QuestionAnswersState loaded({
    String error,
    String message,
    List<Answer> data,
    bool success = true,
  }) {
    return QuestionAnswersState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  QuestionAnswersState failure({
    @required String error,
  }) {
    return QuestionAnswersState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [message, data, error, status, success];
}
