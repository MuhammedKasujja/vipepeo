part of 'topics_bloc.dart';

class TopicsState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<Topic> data;
  final bool success;

  const TopicsState(
      {this.error, this.message, this.status, this.data, this.success});

  TopicsState init() {
    return const TopicsState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  TopicsState load() {
    return TopicsState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  TopicsState loaded({
    String error,
    String message,
    List<Topic> data,
    bool success = true,
  }) {
    return TopicsState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  TopicsState failure({
    @required String error,
  }) {
    return TopicsState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [message, data, error, status, success];
}
