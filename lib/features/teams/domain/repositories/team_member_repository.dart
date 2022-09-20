import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/team_member_model.dart';
import '../../data/models/team_members_filters_model.dart';
import '../../data/models/user_team_id_model.dart';
import '../entities/user_team_id.dart';
import '../entities/user_teams_data.dart';
import '../use_cases/team_member_use_cases.dart';

abstract class TeamMemberRepository {
  Future<Either<Failure, UserTeamsData>> getAllTeamMembersWithFilters(
      TeamMembersFiltersModel teamMembersFiltersModel);

  Future<Either<Failure, List<TeamMemberModel>>> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam);

  Future<Either<Failure, void>> deleteAllTeamMembersByIds(UserTeamIdsWrapper userTeamIdsWrapper);

  Future<Either<Failure, List<int>>> fetchAllTeamMembersByTeamId(int teamId);
}