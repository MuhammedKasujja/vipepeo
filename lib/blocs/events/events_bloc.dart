import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final _repo = Repository();
  EventsBloc()
      : super(const EventsState(
          status: AppStatus.init,
          success: false,
        )) {
    on<FetchEvents>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.getMyMeetups(event.eventType);
        if (event.eventType == EventType.Suggested) {
          emit(state.loaded(suggested: data));
        }
        if (event.eventType == EventType.Saved) {
          emit(state.loaded(saved: data));
        }
        if (event.eventType == EventType.Going) {
          emit(state.loaded(going: data));
        }
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddEditEvent>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.addEditEvent(
            event: event.event,
            postType: event.postType,
            eventId: event.eventId);
        emit(state.loaded(
          message: res.message,
          success: res.success,
        ));
        if (res.success) add(AddRawEvent(event.event));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddRawEvent>((event, emit) async {
      emit(state.loaded());
    });
    on<AttendOrDontAttendEvent>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.attendOrDontAttendEvent(event.eventId);
        emit(state.loaded(
          message: res.message,
          success: res.success,
        ));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<SaveRemoveEvent>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.saveRemoveEvent(event.eventId);
        emit(state.loaded(
          message: res.message,
          success: res.success,
        ));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
  }
}
