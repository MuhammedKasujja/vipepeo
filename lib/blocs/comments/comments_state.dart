part of 'comments_bloc.dart';

class CommentsState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<EventComment> data;
  final bool success;

  const CommentsState(
      {this.error, this.message, this.status, this.data, this.success});

  CommentsState init() {
    return const CommentsState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  CommentsState load() {
    return CommentsState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  CommentsState loaded(
      {String error,
      String message,
      List<EventComment> data,
      bool success = true}) {
    return CommentsState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  CommentsState failure({
    @required String error,
  }) {
    return CommentsState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [message, data, error, status, success];
}
