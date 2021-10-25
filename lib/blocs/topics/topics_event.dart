part of 'topics_bloc.dart';

abstract class TopicsEvent extends Equatable {
  const TopicsEvent();

  @override
  List<Object> get props => [];
}

class FetchTopics extends TopicsEvent {}

class AddTopic extends TopicsEvent {
  final String title;
  final String desc;
  final List conditions;

  const AddTopic(this.title, this.desc, this.conditions);
  @override
  List<Object> get props => [title, desc, conditions];
}
