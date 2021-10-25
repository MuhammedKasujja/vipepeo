import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'child_conditions_event.dart';
part 'child_conditions_state.dart';

class ChildConditionsBloc
    extends Bloc<ChildConditionsEvent, ChildConditionsState> {
  final _repo = Repository();
  ChildConditionsBloc()
      : super(const ChildConditionsState(
          status: AppStatus.init,
          success: false,
        )) {
    on<FetchChildConditions>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.getChildConditions();
        emit(state.loaded(data: data));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
  }
}
