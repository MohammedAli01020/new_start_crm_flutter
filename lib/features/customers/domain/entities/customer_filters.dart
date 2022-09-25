import 'package:equatable/equatable.dart';

class CustomerFilters extends Equatable {
  final int pageNumber;
  final int pageSize;
  final String sortDirection;
  final String sortBy;
  final String? fullNameOrPhoneNumber;
  final String? customerTypes;
  final List<int>? lastEventIds;
  final int? startDateTime;
  final int? endDateTime;
  final int? employeeId;
  final int? teamId;
  final String? reminderTypes;

  final List<String>? unitTypes;
  final List<String>? sources;

  final List<String>? projects;
  final List<String>? developers;

  const CustomerFilters(
      {required this.pageNumber,
      required this.pageSize,
      required this.sortDirection,
      required this.sortBy,
      required this.fullNameOrPhoneNumber,
      required this.customerTypes,
      required this.lastEventIds,
      required this.startDateTime,
      required this.endDateTime,
      required this.employeeId,
      required this.teamId,
      required this.reminderTypes,
      required this.unitTypes,
      required this.sources,
        required this.projects,
        required this.developers,

      });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        sortDirection,
        sortBy,
        fullNameOrPhoneNumber,
        customerTypes,
        lastEventIds,
        startDateTime,
        endDateTime,
        employeeId,
        teamId,
        reminderTypes,
        unitTypes,
        sources,
    projects,
    developers
      ];
}
