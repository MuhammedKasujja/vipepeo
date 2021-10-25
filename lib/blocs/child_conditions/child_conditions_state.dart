part of 'child_conditions_bloc.dart';

class ChildConditionsState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<ChildCondition> data;
  final bool success;

  const ChildConditionsState(
      {this.error, this.message, this.status, this.data, this.success});

  ChildConditionsState init() {
    return const ChildConditionsState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  ChildConditionsState load() {
    return ChildConditionsState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  ChildConditionsState loaded(
      {String error,
      String message,
      List<ChildCondition> data,
      bool success = true}) {
    return ChildConditionsState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  ChildConditionsState failure({
    @required String error,
  }) {
    return ChildConditionsState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [message, data, error, status, success];
}
