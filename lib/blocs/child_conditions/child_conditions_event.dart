part of 'child_conditions_bloc.dart';

abstract class ChildConditionsEvent extends Equatable {
  const ChildConditionsEvent();

  @override
  List<Object> get props => [];
}

class FetchChildConditions extends ChildConditionsEvent {}
