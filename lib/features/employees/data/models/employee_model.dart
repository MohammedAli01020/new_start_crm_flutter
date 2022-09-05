import 'package:crm_flutter_project/features/employees/data/models/phoneNumber_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';

import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel(
      {required int employeeId,
      required String fullName,
      required String? imageUrl,
      required int createDateTime,
      required PhoneNumberModel phoneNumber,
      required bool enabled,
      required String username,
      required String password,
      required List<RoleModel> roles})
      : super(
            employeeId: employeeId,
            fullName: fullName,
            imageUrl: imageUrl,
            createDateTime: createDateTime,
            phoneNumber: phoneNumber,
            enabled: enabled,
            username: username,
            password: password,
            roles: roles);

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        employeeId: json["employeeId"],
        fullName: json["fullName"],
        imageUrl: json["imageUrl"],
        createDateTime: json["createDateTime"],
        phoneNumber: PhoneNumberModel.fromJson(json["phoneNumber"]),
        enabled: json["enabled"],
        username: json["username"],
        password: json["password"],
        roles: List<RoleModel>.from(
            json["roles"].map((x) => RoleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "fullName": fullName,
        "imageUrl": imageUrl,
        "createDateTime": createDateTime,
        "phoneNumber": phoneNumber.toJson(),
        "enabled": enabled,
        "username": username,
        "password": password,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}
