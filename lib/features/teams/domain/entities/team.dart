import 'package:equatable/equatable.dart';

import '../../../employees/data/models/employee_model.dart';

class Team extends Equatable {
  const Team({
    required this.teamId,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.createDateTime,
    required this.teamLeader,
  });

  final int teamId;
  final EmployeeModel? createdBy;
  final String title;
  final String? description;
  final int createDateTime;
  final EmployeeModel? teamLeader;


  @override
  List<Object?> get props =>
      [teamId, createdBy, title, description, createDateTime, teamLeader,];
}