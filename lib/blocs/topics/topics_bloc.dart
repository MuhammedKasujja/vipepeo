import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'topics_event.dart';
part 'topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  final _repo = Repository();
  TopicsBloc()
      : super(const TopicsState(
          status: AppStatus.init,
          success: false,
        )) {
    on<FetchTopics>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.fetchTopics();
        emit(state.loaded(data: data));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddTopic>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.addTopic(
          title: event.title,
          desc: event.desc,
          conditions: event.conditions,
        );
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
