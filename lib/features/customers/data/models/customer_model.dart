import 'package:crm_flutter_project/features/customers/data/models/last_action_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';

import '../../../../core/utils/wrapper.dart';
import '../../../employees/data/models/employee_response_model.dart';
import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel(
      {required int customerId,
      required String fullName,
      required List<String> phoneNumbers,
      required int createDateTime,
      required String? description,
      required List<String> projects,

      required List<String> developers,

      required List<String> unitTypes,
      required List<String> sources,
      required EmployeeResponseModel? createdBy,
      required LastActionModel? lastAction,
      required EmployeeResponseModel? assignedEmployee,
      required EmployeeResponseModel? assignedBy,
      required int? assignedDateTime,

      required int? duplicateNo,

      required bool? viewPreviousLog
      })
      : super(
            customerId: customerId,
            fullName: fullName,
            phoneNumbers: phoneNumbers,
            createDateTime: createDateTime,
            description: description,
            projects: projects,
            developers: developers,
            unitTypes: unitTypes,
            sources: sources,
            createdBy: createdBy,
            lastAction: lastAction,
            assignedEmployee: assignedEmployee,
            assignedBy: assignedBy,
            assignedDateTime: assignedDateTime,

            duplicateNo: duplicateNo,
  viewPreviousLog: viewPreviousLog);

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        customerId: json["customerId"],
        fullName: json["fullName"],
        phoneNumbers: List<String>.from(json["phoneNumbers"].map((x) => x)),
        createDateTime: json["createDateTime"],
        description: json["description"],

    developers: json["developers"] != null
        ? List<String>.from(json["developers"].map((x) => x))
        : [],
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
            ? EmployeeResponseModel.fromJson(json["createdBy"])
            : null,
        lastAction: json["lastAction"] != null
            ? LastActionModel.fromJson(json["lastAction"])
            : null,
        assignedEmployee: json["assignedEmployee"] != null
            ? EmployeeResponseModel.fromJson(json["assignedEmployee"])
            : null,
        assignedBy: json["assignedBy"] != null
            ? EmployeeResponseModel.fromJson(json["assignedBy"])
            : null,
        assignedDateTime: json["assignedDateTime"],
        duplicateNo: json["duplicateNo"],

    viewPreviousLog: json["viewPreviousLog"],

  );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "fullName": fullName,
        "phoneNumbers": List<String>.from(phoneNumbers.map((x) => x)),
        "createDateTime": createDateTime,
        "description": description,
        "developers": List<String>.from(developers.map((x) => x)),
        "projects": List<String>.from(projects.map((x) => x)),
        "unitTypes": List<String>.from(unitTypes.map((x) => x)),
        "sources": List<String>.from(sources.map((x) => x)),
        "createdBy": createdBy?.toJson(),
        "lastAction": lastAction?.toJson(),
        "assignedEmployee": assignedEmployee?.toJson(),
        "assignedBy": assignedBy?.toJson(),
        "assignedDateTime": assignedDateTime,

    "viewPreviousLog": viewPreviousLog,

      };

  CustomerModel copyWith({
    Wrapped<int>? customerId,
    Wrapped<String>? fullName,
    Wrapped<List<String>>? phoneNumbers,
    Wrapped<int>? createDateTime,
    Wrapped<String?>? description,
    Wrapped<List<String>>? projects,
    Wrapped<List<String>>? developers,

    Wrapped<List<String>>? unitTypes,
    Wrapped<List<String>>? sources,
    Wrapped<EmployeeResponseModel?>? createdBy,
    Wrapped<LastActionModel?>? lastAction,
    Wrapped<EmployeeResponseModel?>? assignedEmployee,
    Wrapped<EmployeeResponseModel?>? assignedBy,
    Wrapped<int?>? assignedDateTime,

    Wrapped<int?>? duplicateNo,


    Wrapped<bool?>? viewPreviousLog,

  }) {
    return CustomerModel(
        customerId: customerId != null ? customerId.value : this.customerId,
        fullName: fullName != null ? fullName.value : this.fullName,
        phoneNumbers: phoneNumbers != null ? phoneNumbers.value : this.phoneNumbers,
        createDateTime:
            createDateTime != null ? createDateTime.value : this.createDateTime,
        description: description != null ? description.value : this.description,
        developers: developers != null ? developers.value : this.developers,

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
        duplicateNo: duplicateNo != null ? duplicateNo.value : this.duplicateNo,

      viewPreviousLog: viewPreviousLog != null ? viewPreviousLog.value : this.viewPreviousLog,

    );
  }
}
