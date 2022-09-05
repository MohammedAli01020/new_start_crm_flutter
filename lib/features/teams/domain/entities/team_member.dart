import 'package:equatable/equatable.dart';

import '../../../employees/data/models/employee_model.dart';
import '../../data/models/user_team_id_model.dart';

class TeamMember extends Equatable {
  const TeamMember({
    required this.userTeamId,
    required this.employee,
    required this.insertDateTime,
    required this.insertedBy,
  });

  final UserTeamIdModel userTeamId;
  final EmployeeModel employee;
  final int insertDateTime;
  final EmployeeModel insertedBy;



  @override
  List<Object> get props => [userTeamId, employee, insertDateTime, insertedBy,];
}