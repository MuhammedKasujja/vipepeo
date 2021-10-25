part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends CommentsEvent {
  final dynamic id;

  final CommentType type;

  const FetchComments(this.id, this.type);
  @override
  List<Object> get props => [type, id];
}

class AddComment extends CommentsEvent {
  final dynamic id;
  final CommentType type;
  final String comment;

  const AddComment(this.id, this.comment, this.type);
  @override
  List<Object> get props => [comment, id, type];
}
