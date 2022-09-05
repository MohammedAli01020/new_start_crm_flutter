import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';

import '../../domain/entities/team.dart';

class TeamModel extends Team {
  const TeamModel(
      {required int teamId,
      required EmployeeModel? createdBy,
      required String title,
      required String? description,
      required int createDateTime,
      required EmployeeModel? teamLeader})
      : super(
            teamId: teamId,
            createdBy: createdBy,
            title: title,
            description: description,
            createDateTime: createDateTime,
            teamLeader: teamLeader);

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
        teamId: json["teamId"],
        createdBy: json["createdBy"] != null
            ? EmployeeModel.fromJson(json["createdBy"])
            : null,
        title: json["title"],
        description: json["description"],
        createDateTime: json["createDateTime"],
        teamLeader: json["teamLeader"] != null
            ? EmployeeModel.fromJson(json["teamLeader"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "teamId": teamId,
        "createdBy": createdBy?.toJson(),
        "title": title,
        "description": description,
        "createDateTime": createDateTime,
        "teamLeader": teamLeader?.toJson(),
      };
}
