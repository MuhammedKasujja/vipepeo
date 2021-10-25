part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final User data;
  final bool success;

  const AuthState({
    this.error,
    this.message,
    this.status,
    this.data,
    this.success,
  });

  AuthState init() {
    return const AuthState(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  AuthState load() {
    return AuthState(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  AuthState loaded({
    String error,
    String message,
    User data,
    bool success = true,
  }) {
    return AuthState(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  AuthState failure({
    @required String error,
  }) {
    return AuthState(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [
        message,
        data,
        error,
        status,
        success,
      ];
}
