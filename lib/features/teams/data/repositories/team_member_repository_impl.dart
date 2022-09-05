import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/teams/data/data_sources/team_member_remote_data_source.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_member_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_members_filters_model.dart';
import 'package:crm_flutter_project/features/teams/domain/entities/user_teams_data.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_member_use_cases.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/team_member_repository.dart';

class TeamMemberRepositoryImpl implements TeamMemberRepository {
  final TeamMemberRemoteDataSource teamMemberRemoteDataSource;

  TeamMemberRepositoryImpl({required this.teamMemberRemoteDataSource});

  @override
  Future<Either<Failure, void>> deleteAllTeamMembersByIds(
      List<int> userTeamIds) async {
    try {
      final response = await teamMemberRemoteDataSource
          .deleteAllTeamMembersByIds(userTeamIds);
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
}
