import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_model.dart';

import '../../domain/entities/teams_data.dart';

class TeamsDataModel extends TeamsData {
  const TeamsDataModel(
      {required List<TeamModel> teams,
      required PageableModel pageable,
      required bool last,
      required int totalPages,
      required int totalElements,
      required int size,
      required int number,
      required SortModel sort,
      required bool first,
      required int numberOfElements,
      required bool empty})
      : super(
            teams: teams,
            pageable: pageable,
            last: last,
            totalPages: totalPages,
            totalElements: totalElements,
            size: size,
            number: number,
            sort: sort,
            first: first,
            numberOfElements: numberOfElements,
            empty: empty);

  factory TeamsDataModel.fromJson(Map<String, dynamic> json) => TeamsDataModel(
        teams: List<TeamModel>.from(
            json["content"].map((x) => TeamModel.fromJson(x))),
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

  Map<String, dynamic> toJson() => {
        "teams": List<dynamic>.from(teams.map((x) => x.toJson())),
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
