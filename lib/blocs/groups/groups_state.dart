part of 'groups_bloc.dart';

class GroupsState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<Community> data;
  final bool success;

  const GroupsState(
      {this.error, this.message, this.status, this.data, this.success});

  GroupsState init() {
    return const GroupsState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  GroupsState load() {
    return GroupsState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  GroupsState loaded(
      {String error,
      String message,
      List<Community> data,
      bool success = true}) {
    return GroupsState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  GroupsState failure({
    @required String error,
  }) {
    return GroupsState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [message, data, error, status, success];
}
