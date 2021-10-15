import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'child_conditions_event.dart';
part 'child_conditions_state.dart';

class ChildConditionsBloc extends Bloc<ChildConditionsEvent, ChildConditionsState> {
  ChildConditionsBloc() : super(ChildConditionsInitial()) {
    on<ChildConditionsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
