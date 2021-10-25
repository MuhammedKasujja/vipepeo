import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'questions_event.dart';
part 'questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final _repo = Repository();
  QuestionsBloc()
      : super(const QuestionsState(
          status: AppStatus.init,
          success: false,
        )) {
    on<FetchQuestions>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.fetchQuestions();
        emit(state.loaded(data: data));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddQuestion>((event, emit) async {
      emit(state.load());
      try {
        final res =
            await _repo.askQuestion(event.question, event.childConditions);
        emit(state.loaded(
          message: res.message,
          success: res.success,
        ));
        if (res.success) add(FetchQuestions());
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
  }
}
