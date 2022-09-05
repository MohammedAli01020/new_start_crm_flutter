import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/team_filters_model.dart';
import '../../data/models/team_model.dart';
import '../entities/teams_data.dart';
import '../use_cases/team_use_cases.dart';

abstract class TeamRepository {
  Future<Either<Failure, TeamsData>> getAllTeamsWithFilters(
      TeamFiltersModel teamFiltersModel);

  Future<Either<Failure, TeamModel>> modifyTeam(
      ModifyTeamParam modifyTeamParam);

  Future<Either<Failure, void>> deleteTeam(int teamId);
}
