import 'package:equatable/equatable.dart';

import '../../../../core/utils/wrapper.dart';

class CurrentEmployee extends Equatable {
  const CurrentEmployee({
    required this.permissions,
    required this.fullName,
    required this.employeeId,

    required this.imageUrl,

    required this.enabled,
    required this.token,
    required this.username,
    required this.createDateTime,
    required this.teamId,
  });

  final List<String> permissions;
  final String fullName;
  final int employeeId;

  final String? imageUrl;

  final bool enabled;
  final String token;
  final String username;
  final int createDateTime;
  final int? teamId;

  CurrentEmployee copyWith({
    Wrapped<List<String>>? permissions,
    Wrapped<String>? fullName,
    Wrapped<int>? employeeId,

    Wrapped<String?>? imageUrl,

    Wrapped<bool>? enabled,
    Wrapped<String>? token,
    Wrapped<String>? username,
    Wrapped<int>? createDateTime,
    Wrapped<int?>? teamId,

  }) {
    return CurrentEmployee(
        permissions: permissions != null ? permissions.value : this.permissions,
        fullName: fullName != null ? fullName.value : this.fullName,
        employeeId: employeeId != null ? employeeId.value : this.employeeId,

        imageUrl: imageUrl != null ? imageUrl.value : this.imageUrl,

        enabled: enabled != null ? enabled.value : this.enabled,
        token: token != null ? token.value : this.token,
        username: username != null ? username.value : this.username,
        createDateTime: createDateTime != null ? createDateTime.value : this.createDateTime,
        teamId: teamId != null ? teamId.value : this.teamId);
  }



  @override
  List<Object?> get props =>
      [
        permissions,
        fullName,
        employeeId,
        imageUrl,
        enabled,
        token,
        username,
        createDateTime,
        teamId
      ];
}

