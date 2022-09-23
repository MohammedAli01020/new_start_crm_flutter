import 'package:equatable/equatable.dart';

import '../../../employees/data/models/employee_model.dart';
import '../../data/models/last_action_model.dart';


class Customer extends Equatable {
  const Customer({
    required this.customerId,
    required this.fullName,
    required this.phoneNumbers,
    required this.createDateTime,
    required this.description,
    required this.projects,
    required this.unitTypes,
    required this.sources,
    required this.createdBy,
    required this.lastAction,
    required this.assignedEmployee,
    required this.assignedBy,
    required this.assignedDateTime,
    required this.duplicateNo
  });

  final int customerId;
  final String fullName;
  final List<String> phoneNumbers;
  final int createDateTime;
  final String? description;
  final List<String> projects;
  final List<String> unitTypes;
  final List<String> sources;
  final EmployeeModel? createdBy;
  final LastActionModel? lastAction;
  final EmployeeModel? assignedEmployee;
  final EmployeeModel? assignedBy;
  final int? assignedDateTime;

  final int? duplicateNo;

  @override
  List<Object?> get props =>
      [
        customerId,
        fullName,
        phoneNumbers,
        createDateTime,
        description,
        projects,
        unitTypes,
        sources,
        createdBy,
        lastAction,
        assignedEmployee,
        assignedBy,
        assignedDateTime,
        duplicateNo
      ];
}