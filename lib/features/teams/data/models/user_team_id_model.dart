import '../../domain/entities/user_team_id.dart';

class UserTeamIdModel extends UserTeamId {
  const UserTeamIdModel({required int employeeId, required int teamId}) : super(employeeId: employeeId, teamId: teamId);
  factory UserTeamIdModel.fromJson(Map<String, dynamic> json) =>
      UserTeamIdModel(
        employeeId: json["employeeId"],
        teamId: json["teamId"],
      );

  Map<String, dynamic> toJson() =>
      {
        "employeeId": employeeId,
        "teamId": teamId,
      };
}