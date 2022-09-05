import 'package:crm_flutter_project/core/api/api_consumer.dart';
import 'package:crm_flutter_project/features/teams/data/models/teams_data_model.dart';

import '../../../../core/api/end_points.dart';
import '../../domain/use_cases/team_use_cases.dart';
import '../models/team_filters_model.dart';
import '../models/team_model.dart';

abstract class TeamRemoteDataSource {
  Future<TeamsDataModel> getAllTeamsWithFilters(
      TeamFiltersModel teamFiltersModel);

  Future<TeamModel> modifyTeam(ModifyTeamParam modifyTeamParam);

  Future<void> deleteTeam(int teamId);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final ApiConsumer apiConsumer;

  TeamRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteTeam(int teamId) async {
    return await apiConsumer.delete(
      EndPoints.deleteTeam + teamId.toString(),
    );
  }

  @override
  Future<TeamsDataModel> getAllTeamsWithFilters(
      TeamFiltersModel teamFiltersModel) async {
    final response = await apiConsumer.get(EndPoints.pageTeam,
        queryParameters: teamFiltersModel.toJson());

    return TeamsDataModel.fromJson(response);
  }

  @override
  Future<TeamModel> modifyTeam(ModifyTeamParam modifyTeamParam) async {
    final response = await apiConsumer.post(EndPoints.modifyTeam,
        body: modifyTeamParam.toJson());

    return TeamModel.fromJson(response);
  }
}
