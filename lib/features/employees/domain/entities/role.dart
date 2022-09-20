import 'package:equatable/equatable.dart';

import '../../data/models/permission_model.dart';

class Role extends Equatable {
  const Role({
    required this.roleId,
    required this.name,
    required this.permissions,
  });

  final int? roleId;
  final String name;
  final List<PermissionModel> permissions;

  @override
  List<Object?> get props => [roleId, name, permissions];
}
