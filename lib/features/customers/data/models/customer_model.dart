import 'package:crm_flutter_project/features/customers/data/models/last_action_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/phoneNumber_model.dart';

import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel(
      {required int customerId,
      required String fullName,
      required PhoneNumberModel phoneNumber,
      required int createDateTime,
      required String? description,
      required List<String> projects,
      required List<String> unitTypes,
      required List<String> sources,
      required EmployeeModel? createdBy,
      required LastActionModel? lastAction,
      required EmployeeModel? assignedEmployee,
      required EmployeeModel? assignedBy,
      required int? assignedDateTime,

      required int? duplicateNo})
      : super(
            customerId: customerId,
            fullName: fullName,
            phoneNumber: phoneNumber,
            createDateTime: createDateTime,
            description: description,
            projects: projects,
            unitTypes: unitTypes,
            sources: sources,
            createdBy: createdBy,
            lastAction: lastAction,
            assignedEmployee: assignedEmployee,
            assignedBy: assignedBy,
            assignedDateTime: assignedDateTime,

            duplicateNo: duplicateNo);

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        customerId: json["customerId"],
        fullName: json["fullName"],
        phoneNumber: PhoneNumberModel.fromJson(json["phoneNumber"]),
        createDateTime: json["createDateTime"],
        description: json["description"],
        projects: json["projects"] != null
            ? List<String>.from(json["projects"].map((x) => x))
            : [],
        unitTypes: json["unitTypes"] != null
            ? List<String>.from(json["unitTypes"].map((x) => x))
            : [],
        sources: json["sources"] != null
            ? List<String>.from(json["sources"].map((x) => x))
            : [],
        createdBy: json["createdBy"] != null
            ? EmployeeModel.fromJson(json["createdBy"])
            : null,
        lastAction: json["lastAction"] != null
            ? LastActionModel.fromJson(json["lastAction"])
            : null,
        assignedEmployee: json["assignedEmployee"] != null
            ? EmployeeModel.fromJson(json["assignedEmployee"])
            : null,
        assignedBy: json["assignedBy"] != null
            ? EmployeeModel.fromJson(json["assignedBy"])
            : null,
        assignedDateTime: json["assignedDateTime"],
        duplicateNo: json["duplicateNo"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "fullName": fullName,
        "phoneNumber": phoneNumber.toJson(),
        "createDateTime": createDateTime,
        "description": description,
        "projects": List<String>.from(projects.map((x) => x)),
        "unitTypes": List<String>.from(unitTypes.map((x) => x)),
        "sources": List<String>.from(sources.map((x) => x)),
        "createdBy": createdBy?.toJson(),
        "lastAction": lastAction?.toJson(),
        "assignedEmployee": assignedEmployee?.toJson(),
        "assignedBy": assignedBy?.toJson(),
        "assignedDateTime": assignedDateTime,

      };

  CustomerModel copyWith({
    Wrapped<int>? customerId,
    Wrapped<String>? fullName,
    Wrapped<PhoneNumberModel>? phoneNumber,
    Wrapped<int>? createDateTime,
    Wrapped<String?>? description,
    Wrapped<List<String>>? projects,
    Wrapped<List<String>>? unitTypes,
    Wrapped<List<String>>? sources,
    Wrapped<EmployeeModel?>? createdBy,
    Wrapped<LastActionModel?>? lastAction,
    Wrapped<EmployeeModel?>? assignedEmployee,
    Wrapped<EmployeeModel?>? assignedBy,
    Wrapped<int?>? assignedDateTime,

    Wrapped<int?>? duplicateNo,
  }) {
    return CustomerModel(
        customerId: customerId != null ? customerId.value : this.customerId,
        fullName: fullName != null ? fullName.value : this.fullName,
        phoneNumber: phoneNumber != null ? phoneNumber.value : this.phoneNumber,
        createDateTime:
            createDateTime != null ? createDateTime.value : this.createDateTime,
        description: description != null ? description.value : this.description,
        projects: projects != null ? projects.value : this.projects,
        unitTypes: unitTypes != null ? unitTypes.value : this.unitTypes,
        sources: sources != null ? sources.value : this.sources,
        createdBy: createdBy != null ? createdBy.value : this.createdBy,
        lastAction: lastAction != null ? lastAction.value : this.lastAction,
        assignedEmployee: assignedEmployee != null
            ? assignedEmployee.value
            : this.assignedEmployee,
        assignedBy: assignedBy != null ? assignedBy.value : this.assignedBy,
        assignedDateTime: assignedDateTime != null
            ? assignedDateTime.value
            : this.assignedDateTime,
        duplicateNo:
            duplicateNo != null ? duplicateNo.value : this.duplicateNo);
  }
}
