import '../../domain/entities/permission.dart';

class PermissionModel extends Permission {
  const PermissionModel({required int permissionId, required String name})
      : super(permissionId: permissionId, name: name);

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        permissionId: json["permissionId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "permissionId": permissionId,
        "name": name,
      };
}
