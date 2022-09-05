import 'package:crm_flutter_project/features/teams/data/models/team_model.dart';
import 'package:crm_flutter_project/features/teams/domain/entities/teams_data.dart';
import 'package:crm_flutter_project/features/teams/domain/repositories/team_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/team_filters_model.dart';

abstract class TeamUseCases {
  Future<Either<Failure, TeamsData>> getAllTeamsWithFilters(
      TeamFiltersModel teamFiltersModel);

  Future<Either<Failure, TeamModel>> modifyTeam(
      ModifyTeamParam modifyTeamParam);

  Future<Either<Failure, void>> deleteTeam(int teamId);
}

class TeamUseCasesImpl implements TeamUseCases {
  final TeamRepository teamRepository;

  TeamUseCasesImpl({required this.teamRepository});

  @override
  Future<Either<Failure, void>> deleteTeam(int teamId) {
    return teamRepository.deleteTeam(teamId);
  }

  @override
  Future<Either<Failure, TeamsData>> getAllTeamsWithFilters(
      TeamFiltersModel teamFiltersModel) {
    return teamRepository.getAllTeamsWithFilters(teamFiltersModel);
  }

  @override
  Future<Either<Failure, TeamModel>> modifyTeam(
      ModifyTeamParam modifyTeamParam) {
    return teamRepository.modifyTeam(modifyTeamParam);
  }
}

class ModifyTeamParam extends Equatable {
  final int? teamId;

  final String title;

  final String? description;

  final int? createdByEmployeeId;

  final int createDateTime;

  final int? teamLeaderId;

  const ModifyTeamParam(
      {required this.teamId,
      required this.title,
      required this.description,
      required this.createdByEmployeeId,
      required this.createDateTime,
      required this.teamLeaderId});

  Map<String, dynamic> toJson() => {
        "teamId": teamId,
        "title": title,
        "description": description,
        "createdByEmployeeId": createdByEmployeeId,
        "createDateTime": createDateTime,
        "teamLeaderId": teamLeaderId,
      };

  @override
  List<Object?> get props => [
        teamId,
        title,
        description,
        createdByEmployeeId,
        createDateTime,
        teamLeaderId,
      ];
}
