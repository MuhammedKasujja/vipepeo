import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc() : super(GroupsInitial()) {
    on<GroupsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
