import 'package:crm_flutter_project/features/teams/data/models/user_teams_data_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/use_cases/team_member_use_cases.dart';
import '../models/team_member_model.dart';
import '../models/team_members_filters_model.dart';

abstract class TeamMemberRemoteDataSource {
  Future<UserTeamsDataModel> getAllTeamMembersWithFilters(
      TeamMembersFiltersModel teamMembersFiltersModel);

  Future<List<TeamMemberModel>> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam);

  Future<void> deleteAllTeamMembersByIds(List<int> userTeamIds);
}

class TeamMemberRemoteDataSourceImpl implements TeamMemberRemoteDataSource {
  final ApiConsumer apiConsumer;

  TeamMemberRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteAllTeamMembersByIds(List<int> userTeamIds) async {
    return await apiConsumer.delete(EndPoints.deleteAllTeamMembersByIds,
        queryParameters: {"userTeamIds": userTeamIds});
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
    return await apiConsumer.post(EndPoints.insertAllTeamMember,
        body: insertBulkTeamMembersParam.toJson());
  }
}
