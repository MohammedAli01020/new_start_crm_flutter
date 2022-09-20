import 'package:crm_flutter_project/features/employees/data/models/permission_model.dart';

import '../../domain/entities/role.dart';

class RoleModel extends Role {
  const RoleModel(
      {required int? roleId,
      required String name,
      required List<PermissionModel> permissions})
      : super(roleId: roleId, name: name, permissions: permissions);

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        roleId: json["roleId"],
        name: json["name"],
        permissions: json["permissions"] != null ? List<PermissionModel>.from(
            json["permissions"].map((x) => PermissionModel.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "roleId": roleId,
        "name": name,
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
      };
}
