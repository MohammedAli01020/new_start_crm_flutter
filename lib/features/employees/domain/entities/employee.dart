import 'package:equatable/equatable.dart';

import '../../data/models/role_model.dart';

class Employee extends Equatable {
  const Employee({
    required this.employeeId,
    required this.fullName,
    required this.imageUrl,
    required this.createDateTime,
    required this.phoneNumber,
    required this.enabled,
    required this.username,
    required this.password,
    required this.role,
    required this.createdBy,
    required this.team,
  });

  final int employeeId;
  final String fullName;
  final String? imageUrl;
  final int createDateTime;
  final String phoneNumber;
  final bool enabled;
  final String username;
  final String password;
  final RoleModel? role;

  final int? createdBy;
  final int? team;

  @override
  List<Object?> get props => [
        employeeId,
        fullName,
        imageUrl,
        createDateTime,
        phoneNumber,
        enabled,
        username,
        password,
        role,
        createdBy,
        team
      ];
}
