import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';

import '../../domain/entities/customer_log.dart';

class CustomerLogModel extends CustomerLog {
  const CustomerLogModel({required int customerLogId, required CustomerModel? customer, required EmployeeModel? employee, required int dateTime, required String? description}) : super(customerLogId: customerLogId, customer: customer, employee: employee, dateTime: dateTime, description: description);

  factory CustomerLogModel.fromJson(Map<String, dynamic> json) =>
      CustomerLogModel(
        customerLogId: json["customerLogId"],
        customer: json["customer"] != null ? CustomerModel.fromJson(
            json["customer"]) : null,
        employee: json["employee"] != null ? EmployeeModel.fromJson(
            json["employee"]) : null,
        dateTime: json["dateTime"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() =>
      {
        "customerLogId": customerLogId,
        "customer": customer?.toJson(),
        "employee": employee?.toJson(),
        "dateTime": dateTime,
        "description": description,
      };
}