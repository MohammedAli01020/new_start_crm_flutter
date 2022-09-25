import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';

import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/team_filters.dart';

class TeamFiltersModel extends TeamFilters {
  const TeamFiltersModel(
      {required int pageNumber,
      required int pageSize,
      required String sortDirection,
      required String sortBy,
      required int? createdByEmployeeId,
      required String? search,
      required int? teamLeaderId,
      required int? startDateTime,
      required int? endDateTime,
      required String teamTypes})
      : super(
            pageNumber: pageNumber,
            pageSize: pageSize,
            sortDirection: sortDirection,
            sortBy: sortBy,
            createdByEmployeeId: createdByEmployeeId,
            search: search,
            teamLeaderId: teamLeaderId,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            teamTypes: teamTypes);

  factory TeamFiltersModel.fromJson(Map<String, dynamic> json) =>
      TeamFiltersModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        sortDirection: json["sortDirection"],
        sortBy: json["sortBy"],
        createdByEmployeeId: json["createdByEmployeeId"],
        search: json["search"],
        teamLeaderId: json["teamLeaderId"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
        teamTypes: json["teamTypes"],
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "sortDirection": sortDirection,
        "sortBy": sortBy,
        "createdByEmployeeId": createdByEmployeeId,
        "search": search,
        "teamLeaderId": teamLeaderId,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "teamTypes": teamTypes
      };

  TeamFiltersModel copyWith({
    Wrapped<int>? pageNumber,
    Wrapped<int>? pageSize,
    Wrapped<String>? sortDirection,
    Wrapped<String>? sortBy,
    Wrapped<int?>? createdByEmployeeId,
    Wrapped<String?>? search,
    Wrapped<int?>? teamLeaderId,
    Wrapped<int?>? startDateTime,
    Wrapped<int?>? endDateTime,
    Wrapped<String>? teamTypes,
  }) {
    return TeamFiltersModel(
      pageNumber: pageNumber != null ? pageNumber.value : this.pageNumber,
      pageSize: pageSize != null ? pageSize.value : this.pageSize,
      sortDirection:
          sortDirection != null ? sortDirection.value : this.sortDirection,
      sortBy: sortBy != null ? sortBy.value : this.sortBy,
      createdByEmployeeId: createdByEmployeeId != null
          ? createdByEmployeeId.value
          : this.createdByEmployeeId,
      search: search != null ? search.value : this.search,
      teamLeaderId:
          teamLeaderId != null ? teamLeaderId.value : this.teamLeaderId,
      startDateTime:
          startDateTime != null ? startDateTime.value : this.startDateTime,
      endDateTime: endDateTime != null ? endDateTime.value : this.endDateTime,
      teamTypes: teamTypes != null ? teamTypes.value : this.teamTypes,
    );
  }

  factory TeamFiltersModel.initial() {
    return TeamFiltersModel(
        pageNumber: 0,
        pageSize: 35,
        sortDirection: "DESC",
        sortBy: "createDateTime",
        endDateTime: null,
        startDateTime: null,
        createdByEmployeeId: Constants.currentEmployee!.permissions
                .contains(AppStrings.viewOwnGroups)
            ? Constants.currentEmployee!.employeeId
            : null,
        search: null,
        teamLeaderId: Constants.currentEmployee!.permissions
                .contains(AppStrings.viewOwnGroups)
            ? Constants.currentEmployee!.employeeId
            : null,
        teamTypes: Constants.currentEmployee!.permissions
                .contains(AppStrings.viewOwnGroups)
            ? TeamTypes.ME.name
            : TeamTypes.ALL.name);
  }
}
