import 'package:crm_flutter_project/features/teams/data/models/team_member_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_members_filters_model.dart';
import 'package:crm_flutter_project/features/teams/domain/entities/user_teams_data.dart';
import 'package:crm_flutter_project/features/teams/domain/repositories/team_member_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/user_team_id_model.dart';

abstract class TeamMemberUseCases {
  Future<Either<Failure, UserTeamsData>> getAllTeamMembersWithFilters(
      TeamMembersFiltersModel teamMembersFiltersModel);

  Future<Either<Failure, List<TeamMemberModel>>> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam);

  Future<Either<Failure, void>> deleteAllTeamMembersByIds(
      UserTeamIdsWrapper userTeamIdsWrapper);


  Future<Either<Failure, List<int>>> fetchAllTeamMembersByTeamId(int teamId);
}

class TeamMemberUseCasesImpl implements TeamMemberUseCases {
  final TeamMemberRepository teamMemberRepository;

  TeamMemberUseCasesImpl({required this.teamMemberRepository});

  @override
  Future<Either<Failure, UserTeamsData>> getAllTeamMembersWithFilters(
      TeamMembersFiltersModel teamMembersFiltersModel) {
    return teamMemberRepository
        .getAllTeamMembersWithFilters(teamMembersFiltersModel);
  }

  @override
  Future<Either<Failure, void>> deleteAllTeamMembersByIds(
      UserTeamIdsWrapper userTeamIdsWrapper) {
    return teamMemberRepository.deleteAllTeamMembersByIds(userTeamIdsWrapper);
  }

  @override
  Future<Either<Failure, List<TeamMemberModel>>> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam) {
    return teamMemberRepository
        .insertBulkTeamMembers(insertBulkTeamMembersParam);
  }

  @override
  Future<Either<Failure, List<int>>> fetchAllTeamMembersByTeamId(int teamId) {
    return teamMemberRepository
        .fetchAllTeamMembersByTeamId(teamId);
  }
}

class InsertBulkTeamMembersParam extends Equatable {
  final List<int> employeeIds;
  final int teamId;
  final int insertDateTime;
  final int? insertedByEmployeeId;

  const InsertBulkTeamMembersParam({required this.employeeIds,
    required this.teamId,
    required this.insertDateTime,
    required this.insertedByEmployeeId});

  Map<String, dynamic> toJson() =>
      {
        "employeeIds": employeeIds,
        "teamId": teamId,
        "insertDateTime": insertDateTime,
        "insertedByEmployeeId": insertedByEmployeeId
      };

  @override
  List<Object?> get props =>
      [
        employeeIds,
        teamId,
        insertDateTime,
        insertedByEmployeeId,
      ];
}


class UserTeamIdsWrapper extends Equatable {
  final List<UserTeamIdModel> userTeamIds;

  const UserTeamIdsWrapper({required this.userTeamIds});


  Map<String, dynamic> toJson() =>
      {
        "userTeamIds": List<dynamic>.from(userTeamIds.map((e) => e.toJson())),
      };

  @override
  List<Object> get props => [userTeamIds];
}
