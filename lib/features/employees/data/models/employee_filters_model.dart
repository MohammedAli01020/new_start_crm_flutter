import 'package:crm_flutter_project/features/employees/domain/entities/employee_filters.dart';

import '../../../../core/utils/wrapper.dart';

class EmployeeFiltersModel extends EmployeeFilters {
  const EmployeeFiltersModel(
      {required int pageNumber,
      required int pageSize,
      required String sortDirection,
      required String sortBy,
      required String? fullNameOrPhoneNumber,
      required String? employeeTypes,
      required int? startDateTime,
      required int? endDateTime,
        required int? notInThisTeamId,
      })
      : super(
            pageNumber: pageNumber,
            pageSize: pageSize,
            sortDirection: sortDirection,
            sortBy: sortBy,
            fullNameOrPhoneNumber: fullNameOrPhoneNumber,
            employeeTypes: employeeTypes,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
      notInThisTeamId: notInThisTeamId);

  factory EmployeeFiltersModel.fromJson(Map<String, dynamic> json) =>
      EmployeeFiltersModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        sortDirection: json["sortDirection"],
        sortBy: json["sortBy"],
        fullNameOrPhoneNumber: json["fullNameOrPhoneNumber"],
        employeeTypes: json["employeeTypes"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
          notInThisTeamId: json["notInThisTeamId"],
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "sortDirection": sortDirection,
        "sortBy": sortBy,
        "fullNameOrPhoneNumber": fullNameOrPhoneNumber,
        "employeeTypes": employeeTypes,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
    "notInThisTeamId": notInThisTeamId
  };

  EmployeeFiltersModel copyWith({
    Wrapped<int>? pageNumber,
    Wrapped<int>? pageSize,
    Wrapped<String>? sortDirection,
    Wrapped<String>? sortBy,
    Wrapped<String?>? fullNameOrPhoneNumber,
    Wrapped<String?>? employeeTypes,
    Wrapped<int?>? startDateTime,
    Wrapped<int?>? endDateTime,
    Wrapped<int?>? notInThisTeamId,


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
      employeeTypes:
          employeeTypes != null ? employeeTypes.value : this.employeeTypes,
      startDateTime:
          startDateTime != null ? startDateTime.value : this.startDateTime,
      endDateTime: endDateTime != null ? endDateTime.value : this.endDateTime,
      notInThisTeamId: notInThisTeamId != null ? notInThisTeamId.value : this.notInThisTeamId,

    );
  }

  factory EmployeeFiltersModel.initial() {
    return const EmployeeFiltersModel(
        pageNumber: 0,
        pageSize: 12,
        sortDirection: "DESC",
        sortBy: "createDateTime",
        fullNameOrPhoneNumber: null,
        startDateTime: null,
        endDateTime: null,
        employeeTypes: null,
      notInThisTeamId: null,
    );
  }
}
