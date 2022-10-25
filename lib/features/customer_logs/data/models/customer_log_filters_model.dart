import 'package:crm_flutter_project/features/customer_logs/domain/entities/customer_log_filters.dart';

import '../../../../core/utils/wrapper.dart';

class CustomerLogFiltersModel extends CustomerLogFilters {
  const CustomerLogFiltersModel(
      {required int pageNumber,
      required int pageSize,
      required String sortDirection,
      required String sortBy,
      required int? customerId,
      required int? employeeId,
      required int? startDateTime,
      required int? endDateTime})
      : super(
            pageNumber: pageNumber,
            pageSize: pageSize,
            sortDirection: sortDirection,
            sortBy: sortBy,
            customerId: customerId,
            employeeId: employeeId,
            startDateTime: startDateTime,
            endDateTime: endDateTime);

  factory CustomerLogFiltersModel.fromJson(Map<String, dynamic> json) =>
      CustomerLogFiltersModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        sortDirection: json["sortDirection"],
        sortBy: json["sortBy"],
        customerId: json["customerId"],
        employeeId: json["employeeId"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "sortDirection": sortDirection,
        "sortBy": sortBy,
        "customerId": customerId,
        "employeeId": employeeId,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
      };

  CustomerLogFiltersModel copyWith({
    Wrapped<int>? pageNumber,
    Wrapped<int>? pageSize,
    Wrapped<String>? sortDirection,
    Wrapped<String>? sortBy,
    Wrapped<int?>? customerId,
    Wrapped<int?>? employeeId,
    Wrapped<int?>? startDateTime,
    Wrapped<int?>? endDateTime,
  }) {
    return CustomerLogFiltersModel(
      pageNumber: pageNumber != null ? pageNumber.value : this.pageNumber,
      pageSize: pageSize != null ? pageSize.value : this.pageSize,
      sortDirection:
          sortDirection != null ? sortDirection.value : this.sortDirection,
      sortBy: sortBy != null ? sortBy.value : this.sortBy,
      customerId: customerId != null ? customerId.value : this.customerId,
      employeeId: employeeId != null ? employeeId.value : this.employeeId,
      startDateTime:
          startDateTime != null ? startDateTime.value : this.startDateTime,
      endDateTime: endDateTime != null ? endDateTime.value : this.endDateTime,
    );
  }

  factory CustomerLogFiltersModel.initial() {
    return const CustomerLogFiltersModel(
      pageNumber: 0,
      pageSize: 100,
      sortDirection: "DESC",
      sortBy: "dateTime",
      customerId: null,
      employeeId: null,
      startDateTime: null,
      endDateTime: null,
    );
  }
}
