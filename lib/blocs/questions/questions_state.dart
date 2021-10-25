part of 'questions_bloc.dart';

class QuestionsState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<Question> data;
  final bool success;

  const QuestionsState(
      {this.error, this.message, this.status, this.data, this.success});

  QuestionsState init() {
    return const QuestionsState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  QuestionsState load() {
    return QuestionsState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  QuestionsState loaded({
    String error,
    String message,
    List<Question> data,
    bool success = true,
  }) {
    return QuestionsState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  QuestionsState failure({
    @required String error,
  }) {
    return QuestionsState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [message, data, error, status, success];
}
