import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final _repo = Repository();
  GroupsBloc()
      : super(const GroupsState(
          status: AppStatus.init,
          success: false,
        )) {
    on<FetchGroups>((event, emit) async {
      emit(state.load());
      try {
        final data = await _repo.getMyGroups();
        emit(state.loaded(data: data));
      } catch (error) {
        print({'ChildConditionsError': error});
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddEditGroup>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.addEditCommunity(
            community: event.community,
            postType: event.postType,
            communityId: event.communityId);
        emit(state.loaded(
          message: res.message,
          success: res.success,
        ));
        if (res.success) add(AddRawCommunity(event.community));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddRawCommunity>((event, emit) async {
      emit(state.loaded());
    });
    on<JoinOrLeaveCommunity>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.joinOrLeaveGroup(event.communityId);
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
