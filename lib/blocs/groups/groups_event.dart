part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class FetchGroups extends GroupsEvent {}

class AddEditGroup extends GroupsEvent {
  final Community community;
  final PostData postType;
  final dynamic communityId;

  const AddEditGroup(this.community,
      {this.postType = PostData.Save, this.communityId});
  @override
  List<Object> get props => [community, postType, communityId];
}

class AddRawCommunity extends GroupsEvent {
  final Community community;

  const AddRawCommunity(this.community);
  @override
  List<Object> get props => [community];
}

class JoinOrLeaveCommunity extends GroupsEvent {
  final dynamic communityId;

  const JoinOrLeaveCommunity(this.communityId);
  @override
  List<Object> get props => [communityId];
}
