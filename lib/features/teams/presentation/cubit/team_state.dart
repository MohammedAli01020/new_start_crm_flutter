part of 'team_cubit.dart';

@immutable
abstract class TeamState extends Equatable{

  @override
  List<Object?> get props => [];
}

class TeamInitial extends TeamState {}

class StartUpdateFilter extends TeamState {}

class EndUpdateFilter extends TeamState {}

class StartResetFilter extends TeamState {}

class EndResetFilter extends TeamState {}

class StartRefreshTeams extends TeamState {}

class EndRefreshTeams extends TeamState {}

class RefreshTeamsError extends TeamState {
  final String msg;

  RefreshTeamsError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartLoadingTeams extends TeamState {}

class EndLoadingTeams extends TeamState {}

class LoadingTeamsError extends TeamState {
  final String msg;

  LoadingTeamsError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoadNoMoreTeams extends TeamState {}

// modify

class StartModifyTeam extends TeamState {}
class EndModifyTeam extends TeamState {
  final TeamModel teamModel;

  EndModifyTeam({required this.teamModel});

  @override
  List<Object> get props => [teamModel];
}

class ModifyTeamError extends TeamState {
  final String msg;

  ModifyTeamError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteTeam extends TeamState {}

class EndDeleteTeam extends TeamState {
  final int teamId;

  EndDeleteTeam({required this.teamId});

  @override
  List<Object> get props => [teamId];
}

class DeleteTeamError extends TeamState {
  final String msg;

  DeleteTeamError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartChangeCurrentPage extends TeamState{}
class EndChangeCurrentPage extends TeamState{}
