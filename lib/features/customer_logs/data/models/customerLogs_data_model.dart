import 'package:crm_flutter_project/features/customer_logs/data/models/customer_log_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';

import '../../domain/entities/customer_logs_data.dart';

class CustomerLogsDataModel extends CustomerLogsData {
  const CustomerLogsDataModel({required List<CustomerLogModel> customerLogs, required PageableModel pageable, required bool last, required int totalElements, required int totalPages, required int size, required int number, required SortModel sort, required bool first, required int numberOfElements, required bool empty}) : super(customerLogs: customerLogs, pageable: pageable, last: last, totalElements: totalElements, totalPages: totalPages, size: size, number: number, sort: sort, first: first, numberOfElements: numberOfElements, empty: empty);
  factory CustomerLogsDataModel.fromJson(Map<String, dynamic> json) =>
      CustomerLogsDataModel(
        customerLogs: List<CustomerLogModel>.from(
            json["content"].map((x) => CustomerLogModel.fromJson(x))),
        pageable: PageableModel.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: SortModel.fromJson(json["sort"]),
        first: json["first"],
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() =>
      {
        "customerLogs": List<dynamic>.from(customerLogs.map((x) => x.toJson())),
        "pageable": pageable.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort.toJson(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}