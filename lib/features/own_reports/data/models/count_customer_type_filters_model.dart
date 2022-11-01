import 'package:crm_flutter_project/core/utils/constants.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/count_customer_type_filters.dart';

class CountCustomerTypeFiltersModel extends CountCustomerTypeFilters {
  const CountCustomerTypeFiltersModel(
      {required int? employeeId,
      required int? teamId,
      required int? startDate,
      required int? endDate,
      required String? reminderTypes,
      required int? reminderStartTime,
      required int? reminderEndTime,
      required String employeeReportType})
      : super(
            employeeId: employeeId,
            teamId: teamId,
            startDate: startDate,
            endDate: endDate,
            reminderTypes: reminderTypes,
            reminderStartTime: reminderStartTime,
            reminderEndTime: reminderEndTime,
            employeeReportType: employeeReportType);

  factory CountCustomerTypeFiltersModel.fromJson(Map<String, dynamic> json) =>
      CountCustomerTypeFiltersModel(
        employeeId: json["employeeId"],
        teamId: json["teamId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        reminderTypes: json["reminderTypes"],
        reminderStartTime: json["reminderStartTime"],
        reminderEndTime: json["reminderEndTime"],
        employeeReportType: json["employeeReportType"],
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "teamId": teamId,
        "startDate": startDate,
        "endDate": endDate,
        "reminderTypes": reminderTypes,
        "reminderStartTime": reminderStartTime,
        "reminderEndTime": reminderEndTime,
        "employeeReportType": employeeReportType,
      };

  CountCustomerTypeFiltersModel copyWith({
    Wrapped<int?>? employeeId,
    Wrapped<int?>? teamId,
    Wrapped<int?>? startDate,
    Wrapped<int?>? endDate,
    Wrapped<String?>? reminderTypes,
    Wrapped<int?>? reminderStartTime,
    Wrapped<int?>? reminderEndTime,
    Wrapped<String>? employeeReportType,
  }) {
    return CountCustomerTypeFiltersModel(
      employeeId: employeeId != null ? employeeId.value : this.employeeId,
      teamId: teamId != null ? teamId.value : this.teamId,
      startDate: startDate != null ? startDate.value : this.startDate,
      endDate: endDate != null ? endDate.value : this.endDate,
      reminderTypes:
          reminderTypes != null ? reminderTypes.value : this.reminderTypes,
      reminderStartTime: reminderStartTime != null
          ? reminderStartTime.value
          : this.reminderStartTime,
      reminderEndTime: reminderEndTime != null
          ? reminderEndTime.value
          : this.reminderEndTime,
      employeeReportType: employeeReportType != null
          ? employeeReportType.value
          : this.employeeReportType,
    );
  }

  factory CountCustomerTypeFiltersModel.initial() {
    return CountCustomerTypeFiltersModel(
        employeeId: Constants.currentEmployee?.employeeId,
        teamId: Constants.currentEmployee?.teamId,
        startDate: null,
        endDate: null,
        reminderTypes: null,
        reminderStartTime: null,
        reminderEndTime: null,
        employeeReportType: Constants.currentEmployee!.permissions
                .contains(AppStrings.viewAllStatistics)
            ? EmployeeReportType.ALL.name
            : (Constants.currentEmployee?.teamId != null
                ? EmployeeReportType.ME_AND_TEAM.name
                : EmployeeReportType.ME.name));
  }
}
