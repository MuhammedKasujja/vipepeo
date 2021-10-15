part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();
  
  @override
  List<Object> get props => [];
}

class GroupsInitial extends GroupsState {}
