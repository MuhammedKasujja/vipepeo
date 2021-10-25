part of 'notifications_bloc.dart';

// class NotificationsState extends BaseBlocState<List<NotificationModel>> {
//   const NotificationsState();

//   @override
//   List<Object> get props => [];
// }

class NotificationsState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<NotificationModel> data;
  final bool success;

  const NotificationsState(
      {this.error, this.message, this.status, this.data, this.success});

  NotificationsState init() {
    return const NotificationsState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  NotificationsState load() {
    return NotificationsState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  NotificationsState loaded({
    String error,
    String message,
    List<NotificationModel> data,
    bool success = true,
  }) {
    return NotificationsState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  NotificationsState failure({
    @required String error,
  }) {
    return NotificationsState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [message, data, error, status, success];
}
