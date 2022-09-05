import 'package:equatable/equatable.dart';

import '../../data/models/phoneNumber_model.dart';
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
    required this.roles,
  });

  final int employeeId;
  final String fullName;
  final String? imageUrl;
  final int createDateTime;
  final PhoneNumberModel phoneNumber;
  final bool enabled;
  final String username;
  final String password;
  final List<RoleModel> roles;

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
        roles,
      ];
}
