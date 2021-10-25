import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/base.state.dart';
import 'package:vipepeo_app/models/models.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final _repo = Repository();
  NotificationsBloc() : super(const NotificationsState()) {
    on<FetchNotifications>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.fetchNotifications();
        emit(state.loaded(data: data, success: true));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
  }
}
