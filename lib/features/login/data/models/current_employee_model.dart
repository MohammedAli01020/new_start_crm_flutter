import 'package:crm_flutter_project/features/login/domain/entities/current_employee.dart';

class CurrentEmployeeModel extends CurrentEmployee {
  const CurrentEmployeeModel(
      {required List<String> permissions,
      required String fullName,
      required int employeeId,
      required bool enabled,
      required String token,
      required String username,
      required int createDateTime,
      required int? teamId})
      : super(
            permissions: permissions,
            fullName: fullName,
            employeeId: employeeId,
            enabled: enabled,
            token: token,
            username: username,
            createDateTime: createDateTime,
            teamId: teamId);

  factory CurrentEmployeeModel.fromJson(Map<String, dynamic> json) =>
      CurrentEmployeeModel(
        permissions: List<String>.from(json["permissions"].map((x) => x)),
        fullName: json["fullName"],
        employeeId: json["employeeId"],
        enabled: json["enabled"],
        token: json["token"],
        username: json["username"],
        createDateTime: json["createDateTime"],
        teamId: json["teamId"],
      );

  Map<String, dynamic> toJson() => {
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
        "fullName": fullName,
        "employeeId": employeeId,
        "enabled": enabled,
        "token": token,
        "username": username,
        "createDateTime": createDateTime,
        "teamId": teamId,
      };
}
