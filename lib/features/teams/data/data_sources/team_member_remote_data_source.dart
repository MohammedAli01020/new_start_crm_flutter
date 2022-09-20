import 'package:crm_flutter_project/features/teams/data/models/user_team_id_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/user_teams_data_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/entities/user_team_id.dart';
import '../../domain/use_cases/team_member_use_cases.dart';
import '../models/team_member_model.dart';
import '../models/team_members_filters_model.dart';

abstract class TeamMemberRemoteDataSource {
  Future<UserTeamsDataModel> getAllTeamMembersWithFilters(
      TeamMembersFiltersModel teamMembersFiltersModel);

  Future<List<TeamMemberModel>> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam);

  Future<void> deleteAllTeamMembersByIds(UserTeamIdsWrapper userTeamIdsWrapper);

  Future<List<int>> fetchAllTeamMembersByTeamId(int teamId);
}

class TeamMemberRemoteDataSourceImpl implements TeamMemberRemoteDataSource {
  final ApiConsumer apiConsumer;

  TeamMemberRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteAllTeamMembersByIds(UserTeamIdsWrapper userTeamIdsWrapper) async {
    return await apiConsumer.delete(EndPoints.deleteAllTeamMembersByIds,
        body: userTeamIdsWrapper.toJson()
    );
  }

  @override
  Future<UserTeamsDataModel> getAllTeamMembersWithFilters(
      TeamMembersFiltersModel teamMembersFiltersModel) async {
    final response = await apiConsumer.get(EndPoints.pageTeamMember,
        queryParameters: teamMembersFiltersModel.toJson());

    return UserTeamsDataModel.fromJson(response);
  }

  @override
  Future<List<TeamMemberModel>> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam) async {
    final response = await apiConsumer.post(EndPoints.insertAllTeamMember,
        body: insertBulkTeamMembersParam.toJson());


    return List<TeamMemberModel>.from(response.map((x) => TeamMemberModel.fromJson(x)));
  }

  @override
  Future<List<int>> fetchAllTeamMembersByTeamId(int teamId) async {
    final response = await apiConsumer.get(EndPoints.fetchAllTeamMembersIds + teamId.toString());

    return List<int>.from(response);
  }
}


