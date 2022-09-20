import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/teams/data/data_sources/team_member_remote_data_source.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_member_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_members_filters_model.dart';
import 'package:crm_flutter_project/features/teams/domain/entities/user_teams_data.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_member_use_cases.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_team_id.dart';
import '../../domain/repositories/team_member_repository.dart';
import '../models/user_team_id_model.dart';

class TeamMemberRepositoryImpl implements TeamMemberRepository {
  final TeamMemberRemoteDataSource teamMemberRemoteDataSource;

  TeamMemberRepositoryImpl({required this.teamMemberRemoteDataSource});

  @override
  Future<Either<Failure, void>> deleteAllTeamMembersByIds(
      UserTeamIdsWrapper userTeamIdsWrapper) async {
    try {
      final response = await teamMemberRemoteDataSource
          .deleteAllTeamMembersByIds(userTeamIdsWrapper);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, UserTeamsData>> getAllTeamMembersWithFilters(
      TeamMembersFiltersModel teamMembersFiltersModel) async {
    try {
      final response = await teamMemberRemoteDataSource
          .getAllTeamMembersWithFilters(teamMembersFiltersModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<TeamMemberModel>>> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam) async {
    try {
      final response = await teamMemberRemoteDataSource
          .insertBulkTeamMembers(insertBulkTeamMembersParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<int>>> fetchAllTeamMembersByTeamId(int teamId) async {
    try {
      final response = await teamMemberRemoteDataSource
          .fetchAllTeamMembersByTeamId(teamId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }
}
