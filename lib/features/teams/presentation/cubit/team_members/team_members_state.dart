part of 'team_members_cubit.dart';

@immutable
abstract class TeamMembersState extends Equatable {

  @override
  List<Object> get props => [];
}

class TeamMembersInitial extends TeamMembersState {}


class StartUpdateFilter extends TeamMembersState {}

class EndUpdateFilter extends TeamMembersState {}

class StartResetFilter extends TeamMembersState {}

class EndResetFilter extends TeamMembersState {}

class StartRefreshTeamMembers extends TeamMembersState {}

class EndRefreshTeamMembers extends TeamMembersState {}

class RefreshTeamMembersError extends TeamMembersState {
  final String msg;

  RefreshTeamMembersError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartLoadingTeamMembers extends TeamMembersState {}

class EndLoadingTeamMembers extends TeamMembersState {}

class LoadingTeamMembersError extends TeamMembersState {
  final String msg;

  LoadingTeamMembersError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoadNoMoreTeamMembers extends TeamMembersState {}


class StartUpdateSelectedTeamMembers extends TeamMembersState {}

class EndUpdateSelectedTeamMembers extends TeamMembersState {}

class StartResetSelectedTeamMembers extends TeamMembersState {}

class EndResetSelectedTeamMembers extends TeamMembersState {}


class StartInsertBulkTeamMembers extends TeamMembersState {}

class EndInsertBulkTeamMembers extends TeamMembersState {
  final List<TeamMemberModel> insertedTeamMembers;

  EndInsertBulkTeamMembers({required this.insertedTeamMembers});

  @override
  List<Object> get props => [insertedTeamMembers];
}

class InsertBulkTeamMembersError extends TeamMembersState {
  final String msg;

  InsertBulkTeamMembersError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartFetchAllTeamMembersByTeamId extends TeamMembersState {}
class EndFetchAllTeamMembersByTeamId extends TeamMembersState {
  final List<int> insertedTeamMembersId;

  EndFetchAllTeamMembersByTeamId({required this.insertedTeamMembersId});

  @override
  List<Object> get props => [insertedTeamMembersId];
}
class FetchAllTeamMembersByTeamIdError extends TeamMembersState {
  final String msg;

  FetchAllTeamMembersByTeamIdError({required this.msg});

  @override
  List<Object> get props => [msg];
}



class StartDeleteAllTeamMembersByIds extends TeamMembersState {}

class EndDeleteAllTeamMembersByIds extends TeamMembersState {

}
class DeleteAllTeamMembersByIdsError extends TeamMembersState {
  final String msg;

  DeleteAllTeamMembersByIdsError({required this.msg});

  @override
  List<Object> get props => [msg];
}

