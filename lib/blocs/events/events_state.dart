part of 'events_bloc.dart';

class EventsState extends Equatable {
  final String error;
  final String message;
  final AppStatus status;
  final List<Event> saved;
  final List<Event> going;
  final List<Event> suggested;
  final bool success;

  const EventsState(
      {this.going,
      this.suggested,
      this.error,
      this.message,
      this.status,
      this.saved,
      this.success});

  EventsState init() {
    return const EventsState(
        error: null,
        saved: null,
        going: null,
        suggested: null,
        message: null,
        status: AppStatus.init,
        success: false);
  }

  EventsState load() {
    return EventsState(
        message: null,
        error: null,
        saved: saved,
        going: going,
        suggested: suggested,
        status: AppStatus.loading,
        success: false);
  }

  EventsState loaded({
    String error,
    String message,
    List<Event> saved,
    List<Event> going,
    List<Event> suggested,
    bool success = true,
  }) {
    return EventsState(
        message: message ?? this.message,
        error: error ?? this.error,
        saved: saved ?? this.saved,
        going: going ?? this.going,
        suggested: suggested ?? this.suggested,
        status: AppStatus.loaded,
        success: success);
  }

  EventsState failure({
    @required String error,
  }) {
    return EventsState(
        message: null,
        error: error,
        saved: saved,
        going: saved,
        suggested: suggested,
        status: AppStatus.failure,
        success: false);
  }

  @override
  List<Object> get props => [
        message,
        saved,
        going,
        suggested,
        error,
        status,
        success,
      ];
}
