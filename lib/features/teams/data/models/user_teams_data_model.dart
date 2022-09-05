import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';

import 'package:crm_flutter_project/features/teams/data/models/team_member_model.dart';

import '../../domain/entities/user_teams_data.dart';

class UserTeamsDataModel extends UserTeamsData {
  const UserTeamsDataModel({required List<TeamMemberModel> teamMembers, required PageableModel pageable, required bool last, required int totalPages, required int totalElements, required int size, required int number, required SortModel sort, required bool first, required int numberOfElements, required bool empty}) : super(teamMembers: teamMembers, pageable: pageable, last: last, totalPages: totalPages, totalElements: totalElements, size: size, number: number, sort: sort, first: first, numberOfElements: numberOfElements, empty: empty);

  factory UserTeamsDataModel.fromJson(Map<String, dynamic> json) =>
      UserTeamsDataModel(
        teamMembers: List<TeamMemberModel>.from(
            json["content"].map((x) => TeamMemberModel.fromJson(x))),
        pageable: PageableModel.fromJson(json["pageable"]),
        last: json["last"],
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        size: json["size"],
        number: json["number"],
        sort: SortModel.fromJson(json["sort"]),
        first: json["first"],
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() =>
      {
        "teamMembers": List<dynamic>.from(teamMembers.map((x) => x.toJson())),
        "pageable": pageable.toJson(),
        "last": last,
        "totalPages": totalPages,
        "totalElements": totalElements,
        "size": size,
        "number": number,
        "sort": sort.toJson(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };

}