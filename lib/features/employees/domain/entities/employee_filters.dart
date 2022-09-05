import 'package:equatable/equatable.dart';

class EmployeeFilters extends Equatable {
  final int pageNumber;
  final int pageSize;
  final String sortDirection;
  final String sortBy;
  final String? fullNameOrPhoneNumber;
  final String? employeeTypes;
  final int? startDateTime;
  final int? endDateTime;

  final int? notInThisTeamId;

  const EmployeeFilters(
      {required this.pageNumber,
      required this.pageSize,
      required this.sortDirection,
      required this.sortBy,
      required this.fullNameOrPhoneNumber,
      required this.employeeTypes,
      required this.startDateTime,
      required this.endDateTime,
        required this.notInThisTeamId
      });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        sortDirection,
        sortBy,
        fullNameOrPhoneNumber,
        employeeTypes,
        startDateTime,
        endDateTime,
    notInThisTeamId
      ];
}
