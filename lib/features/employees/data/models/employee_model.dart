
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';

import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required int employeeId,
    required String fullName,
    required String? imageUrl,
    required int createDateTime,
    required String phoneNumber,
    required bool enabled,
    required String username,
    required String password,
    required RoleModel? role,
    required int? createdBy,
    required int? team,
  }) : super(
            employeeId: employeeId,
            fullName: fullName,
            imageUrl: imageUrl,
            createDateTime: createDateTime,
            phoneNumber: phoneNumber,
            enabled: enabled,
            username: username,
            password: password,
            role: role,
            createdBy: createdBy,
            team: team);

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        employeeId: json["employeeId"],
        fullName: json["fullName"],
        imageUrl: json["imageUrl"],
        createDateTime: json["createDateTime"],
        phoneNumber: json["phoneNumber"],
        enabled: json["enabled"],
        username: json["username"],
        password: json["password"],
        role: json["role"] != null ? RoleModel.fromJson(json["role"]) : null,
        createdBy: json["createdBy"],
        team: json["team"],
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "fullName": fullName,
        "imageUrl": imageUrl,
        "createDateTime": createDateTime,
        "phoneNumber": phoneNumber,
        "enabled": enabled,
        "username": username,
        "password": password,
        "roles": role?.toJson(),
        "createdBy": createdBy,
        "team:": team,
      };
}
