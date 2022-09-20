import '../../../customers/data/models/customer_model.dart';
import '../../../employees/data/models/employee_model.dart';
import 'package:equatable/equatable.dart';

class CustomerLog extends Equatable {
  const CustomerLog({
    required this.customerLogId,
    required this.customer,
    required this.employee,
    required this.dateTime,
    required this.description,
  });

  final int customerLogId;
  final CustomerModel? customer;
  final EmployeeModel? employee;
  final int dateTime;
  final String? description;



  @override
  List<Object?> get props =>
      [customerLogId, customer, employee, dateTime, description,];
}