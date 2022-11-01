import 'package:crm_flutter_project/features/employees/domain/entities/employee_filters.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';

class EmployeeFiltersModel extends EmployeeFilters {
  const EmployeeFiltersModel(
      {required int pageNumber,
      required int pageSize,
      required String sortDirection,
      required String sortBy,
      required String? fullNameOrPhoneNumber,
      required String? employeeTypes,
        required int? teamId,

      required int? startDateTime,
      required int? endDateTime,
        required int? excludeTeamLeader,
        required int? notInThisTeamId,
        required int? createdById,
        required bool? availableToAssign

      })
      : super(
            pageNumber: pageNumber,
            pageSize: pageSize,
            sortDirection: sortDirection,
            sortBy: sortBy,
            fullNameOrPhoneNumber: fullNameOrPhoneNumber,
            employeeTypes: employeeTypes,
            teamId: teamId,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
      excludeTeamLeader: excludeTeamLeader,
      notInThisTeamId: notInThisTeamId,
      createdById: createdById,
      availableToAssign: availableToAssign);

  factory EmployeeFiltersModel.fromJson(Map<String, dynamic> json) =>
      EmployeeFiltersModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        sortDirection: json["sortDirection"],
        sortBy: json["sortBy"],
        fullNameOrPhoneNumber: json["fullNameOrPhoneNumber"],
        employeeTypes: json["employeeTypes"],
        teamId: json["teamId"],

        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
          excludeTeamLeader: json["excludeTeamLeader"],
          notInThisTeamId: json["notInThisTeamId"],

          createdById: json["createdById"],
          availableToAssign: json["availableToAssign"],
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "sortDirection": sortDirection,
        "sortBy": sortBy,
        "fullNameOrPhoneNumber": fullNameOrPhoneNumber,
        "employeeTypes": employeeTypes,

    "teamId": teamId,

    "startDateTime": startDateTime,
        "endDateTime": endDateTime,
    "excludeTeamLeader": excludeTeamLeader,
    "notInThisTeamId": notInThisTeamId,
    "createdById": createdById,
    "availableToAssign": availableToAssign
  };

  EmployeeFiltersModel copyWith({
    Wrapped<int>? pageNumber,
    Wrapped<int>? pageSize,
    Wrapped<String>? sortDirection,
    Wrapped<String>? sortBy,
    Wrapped<String?>? fullNameOrPhoneNumber,
    Wrapped<String?>? employeeTypes,

    Wrapped<int?>? teamId,

    Wrapped<int?>? startDateTime,
    Wrapped<int?>? endDateTime,
    Wrapped<int?>? excludeTeamLeader,
    Wrapped<int?>? notInThisTeamId,
    Wrapped<int?>? createdById,

    Wrapped<bool?>? availableToAssign,


  }) {
    return EmployeeFiltersModel(
      pageNumber: pageNumber != null ? pageNumber.value : this.pageNumber,
      pageSize: pageSize != null ? pageSize.value : this.pageSize,
      sortDirection:
          sortDirection != null ? sortDirection.value : this.sortDirection,
      sortBy: sortBy != null ? sortBy.value : this.sortBy,
      fullNameOrPhoneNumber: fullNameOrPhoneNumber != null
          ? fullNameOrPhoneNumber.value
          : this.fullNameOrPhoneNumber,
      employeeTypes: employeeTypes != null ? employeeTypes.value : this.employeeTypes,

      teamId: teamId != null ? teamId.value : this.teamId,

      startDateTime:
          startDateTime != null ? startDateTime.value : this.startDateTime,
      endDateTime: endDateTime != null ? endDateTime.value : this.endDateTime,
      excludeTeamLeader: excludeTeamLeader != null ? excludeTeamLeader.value : this.excludeTeamLeader,

      notInThisTeamId: notInThisTeamId != null ? notInThisTeamId.value : this.notInThisTeamId,
      createdById: createdById != null ? createdById.value : this.createdById,
      availableToAssign: availableToAssign != null ? availableToAssign.value : this.availableToAssign,

    );
  }

  factory EmployeeFiltersModel.initial() {
    return EmployeeFiltersModel(
        pageNumber: 0,
        pageSize: 50,
        sortDirection: "DESC",
        sortBy: "createDateTime",
        fullNameOrPhoneNumber: null,
        startDateTime: null,
        endDateTime: null,
        employeeTypes: null,
        teamId: Constants.currentEmployee?.teamId,
        excludeTeamLeader: null,
       notInThisTeamId: null,
       createdById: null,
       availableToAssign: null
    );
  }
}
