import 'package:equatable/equatable.dart';

import '../../../../core/utils/wrapper.dart';

class CurrentEmployee extends Equatable {
  const CurrentEmployee({
    required this.permissions,
    required this.fullName,
    required this.employeeId,
    required this.enabled,
    required this.token,
    required this.username,
    required this.createDateTime,
  });

  final List<String> permissions;
  final String fullName;
  final int employeeId;
  final bool enabled;
  final String token;
  final String username;
  final int createDateTime;


  CurrentEmployee copyWith({
    Wrapped<List<String>>? permissions,
    Wrapped<String>? fullName,
    Wrapped<int>? employeeId,
    Wrapped<bool>? enabled,
    Wrapped<String>? token,
    Wrapped<String>? username,
    Wrapped<int>? createDateTime,

  }) {
    return CurrentEmployee(
        permissions: permissions != null ? permissions.value : this.permissions,
        fullName: fullName != null ? fullName.value : this.fullName,
        employeeId: employeeId != null ? employeeId.value : this.employeeId,
        enabled: enabled != null ? enabled.value : this.enabled,
        token: token != null ? token.value : this.token,
        username: username != null ? username.value : this.username,
        createDateTime: createDateTime != null ? createDateTime.value : this.createDateTime);
  }



  @override
  List<Object> get props =>
      [
        permissions,
        fullName,
        employeeId,
        enabled,
        token,
        username,
        createDateTime,
      ];
}

