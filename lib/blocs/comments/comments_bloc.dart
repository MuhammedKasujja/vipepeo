import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final _repo = Repository();
  CommentsBloc()
      : super(const CommentsState(
          status: AppStatus.init,
          success: false,
        )) {
    on<FetchComments>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.fetchComments(event.id, event.type);
        emit(state.loaded(data: data));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddComment>((event, emit) async {
      emit(state.load());
      try {
        if (event.type == CommentType.group) {
          final data = await _repo.makeGroupComment(event.id, event.comment);
          emit(state.loaded(message: data.message, success: data.success));
        }
        if (event.type == CommentType.event) {
          final data = await _repo.makeEventComment(event.id, event.comment);
          emit(state.loaded(message: data.message, success: data.success));
        }
        add(FetchComments(event.id, event.type));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
  }
}
