import 'package:equatable/equatable.dart';

class CountCustomerTypeFilters extends Equatable {
  final int employeeId;
  final int? startDate;
  final int? endDate;
  final String? reminderTypes;
  final int? reminderStartTime;
  final int? reminderEndTime;

  const CountCustomerTypeFilters({required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.reminderTypes,
    required this.reminderStartTime,
    required this.reminderEndTime});


  @override
  List<Object?> get props =>
      [
        employeeId,
        startDate,
        endDate,
        reminderTypes,
        reminderStartTime,
        reminderEndTime,
      ];
}
