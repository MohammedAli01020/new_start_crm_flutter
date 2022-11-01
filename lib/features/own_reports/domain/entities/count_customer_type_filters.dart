import 'package:equatable/equatable.dart';

class CountCustomerTypeFilters extends Equatable {
  final int? employeeId;

  final int? teamId;

  final int? startDate;
  final int? endDate;
  final String? reminderTypes;
  final int? reminderStartTime;
  final int? reminderEndTime;

  final String employeeReportType;



  const CountCustomerTypeFilters({
    required this.employeeId,

    required this.teamId,

    required this.startDate,
    required this.endDate,
    required this.reminderTypes,
    required this.reminderStartTime,
    required this.reminderEndTime,

    required this.employeeReportType,


  });


  @override
  List<Object?> get props =>
      [
        employeeId,
        teamId,
        startDate,
        endDate,
        reminderTypes,
        reminderStartTime,
        reminderEndTime,
        employeeReportType
      ];
}
