import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/teams/data/data_sources/team_remote_data_source.dart';

import 'package:crm_flutter_project/features/teams/data/models/team_filters_model.dart';

import 'package:crm_flutter_project/features/teams/data/models/team_model.dart';

import 'package:crm_flutter_project/features/teams/domain/entities/teams_data.dart';

import 'package:crm_flutter_project/features/teams/domain/use_cases/team_use_cases.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {

  final TeamRemoteDataSource teamRemoteDataSource;

  TeamRepositoryImpl({required this.teamRemoteDataSource});


  @override
  Future<Either<Failure, void>> deleteTeam(int teamId) async {
    try {
      final response = await teamRemoteDataSource.deleteTeam(teamId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, TeamsData>> getAllTeamsWithFilters(TeamFiltersModel teamFiltersModel) async {
    try {
      final response = await teamRemoteDataSource.getAllTeamsWithFilters(teamFiltersModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, TeamModel>> modifyTeam(ModifyTeamParam modifyTeamParam) async {
    try {
      final response = await teamRemoteDataSource.modifyTeam(modifyTeamParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}