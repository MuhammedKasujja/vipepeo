part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class FetchEvents extends EventsEvent {
  final EventType eventType;

  const FetchEvents(this.eventType);
  @override
  List<Object> get props => [eventType];
}

class AddEditEvent extends EventsEvent {
  final Event event;
  final PostData postType;
  final dynamic eventId;

  const AddEditEvent(this.event, {this.postType = PostData.Save, this.eventId});
  @override
  List<Object> get props => [event, postType, eventId];
}

class AddRawEvent extends EventsEvent {
  final Event event;

  const AddRawEvent(this.event);
  @override
  List<Object> get props => [event];
}

class AttendOrDontAttendEvent extends EventsEvent {
  final dynamic eventId;

  const AttendOrDontAttendEvent(this.eventId);
  @override
  List<Object> get props => [eventId];
}

class SaveRemoveEvent extends EventsEvent {
  final dynamic eventId;

  const SaveRemoveEvent(this.eventId);
  @override
  List<Object> get props => [eventId];
}
