import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/models/enums.dart';

abstract class BaseState<T> extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final T data;
  final bool success;

  const BaseState(
      this.error, this.message, this.status, this.data, this.success);
  BaseState<T> init();
  BaseState<T> load();
  BaseState<T> loaded(
      {String error, String message, T data, @required bool success});
  BaseState<T> failure({
    @required String error,
  });
  @override
  List<Object> get props => [message, data, error, status, success];
}

class BaseBlocState<T> extends BaseState<T> {
  final String error;
  final String message;
  final AppStatus status;
  final T data;
  final bool success;

  const BaseBlocState(
      {this.error, this.message, this.status, this.data, this.success})
      : super(error, message, status, data, success);

  @override
  BaseBlocState<T> init() {
    return BaseBlocState<T>(
        error: null,
        data: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  @override
  BaseBlocState<T> load() {
    return BaseBlocState<T>(
        message: null,
        error: null,
        data: data,
        status: AppStatus.loading,
        success: false);
  }

  @override
  BaseBlocState<T> loaded(
      {String error, String message, T data, @required bool success}) {
    return BaseBlocState<T>(
        message: message ?? this.message,
        error: error ?? this.error,
        data: data ?? this.data,
        status: AppStatus.loaded,
        success: success);
  }

  @override
  BaseBlocState<T> failure({
    @required String error,
  }) {
    return BaseBlocState<T>(
        message: null,
        error: error,
        data: data,
        status: AppStatus.failure,
        success: false);
  }
}
