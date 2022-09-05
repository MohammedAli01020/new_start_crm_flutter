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