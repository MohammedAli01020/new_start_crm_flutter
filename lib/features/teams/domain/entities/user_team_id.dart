import 'package:equatable/equatable.dart';

class UserTeamId extends Equatable {
  const UserTeamId({
    required this.employeeId,
    required this.teamId,
  });

  final int employeeId;
  final int teamId;



  @override
  List<Object> get props => [employeeId, teamId];
}