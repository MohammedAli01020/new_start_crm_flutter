import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';

import 'package:crm_flutter_project/features/teams/data/models/user_team_id_model.dart';

import '../../domain/entities/team_member.dart';

class TeamMemberModel extends TeamMember {
  const TeamMemberModel({required UserTeamIdModel userTeamId, required EmployeeModel employee, required int insertDateTime, required EmployeeModel? insertedBy}) : super(userTeamId: userTeamId, employee: employee, insertDateTime: insertDateTime, insertedBy: insertedBy);
  factory TeamMemberModel.fromJson(Map<String, dynamic> json) =>
      TeamMemberModel(
        userTeamId: UserTeamIdModel.fromJson(json["userTeamId"]),
        employee: EmployeeModel.fromJson(json["employee"]),
        insertDateTime: json["insertDateTime"],
        insertedBy: EmployeeModel.fromJson(json["insertedBy"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "userTeamId": userTeamId.toJson(),
        "employee": employee.toJson(),
        "insertDateTime": insertDateTime,
        "insertedBy": insertedBy?.toJson(),
      };
}