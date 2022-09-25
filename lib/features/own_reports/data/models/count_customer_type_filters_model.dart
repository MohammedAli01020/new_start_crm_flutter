import 'package:crm_flutter_project/core/utils/constants.dart';

import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/count_customer_type_filters.dart';

class CountCustomerTypeFiltersModel extends CountCustomerTypeFilters {
  const CountCustomerTypeFiltersModel(
      {required int employeeId,
      required int? startDate,
      required int? endDate,
      required String? reminderTypes,
      required int? reminderStartTime,
      required int? reminderEndTime})
      : super(
            employeeId: employeeId,
            startDate: startDate,
            endDate: endDate,
            reminderTypes: reminderTypes,
            reminderStartTime: reminderStartTime,
            reminderEndTime: reminderEndTime);

  factory CountCustomerTypeFiltersModel.fromJson(Map<String, dynamic> json) =>
      CountCustomerTypeFiltersModel(
        employeeId: json["employeeId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        reminderTypes: json["reminderTypes"],
        reminderStartTime: json["reminderStartTime"],
        reminderEndTime: json["reminderEndTime"],
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "startDate": startDate,
        "endDate": endDate,
        "reminderTypes": reminderTypes,
        "reminderStartTime": reminderStartTime,
        "reminderEndTime": reminderEndTime,
      };

  CountCustomerTypeFiltersModel copyWith({
    Wrapped<int>? employeeId,
    Wrapped<int?>? startDate,
    Wrapped<int?>? endDate,
    Wrapped<String?>? reminderTypes,
    Wrapped<int?>? reminderStartTime,
    Wrapped<int?>? reminderEndTime,
  }) {
    return CountCustomerTypeFiltersModel(
      employeeId: employeeId != null ? employeeId.value : this.employeeId,
      startDate: startDate != null ? startDate.value : this.startDate,
      endDate: endDate != null ? endDate.value : this.endDate,
      reminderTypes: reminderTypes != null ? reminderTypes.value : this.reminderTypes,
      reminderStartTime: reminderStartTime != null ? reminderStartTime.value : this.reminderStartTime,
      reminderEndTime: reminderEndTime != null ? reminderEndTime.value : this.reminderEndTime,
    );
  }

  factory CountCustomerTypeFiltersModel.initial() {
    return  CountCustomerTypeFiltersModel(
        employeeId: Constants.currentEmployee!.employeeId,
        startDate: null,
        endDate: null,
        reminderTypes: null,
        reminderStartTime: null,
        reminderEndTime: null);
  }
}
