import 'package:equatable/equatable.dart';

class TeamFilters extends Equatable {
  final int pageNumber;
  final int pageSize;
  final String sortDirection;
  final String sortBy;

  final int? createdByEmployeeId;

  final String? search;

  final int? teamLeaderId;

  final int? startDateTime;

  final int? endDateTime;

  const TeamFilters({
    required this.pageNumber,
    required this.pageSize,
    required this.sortDirection,
    required this.sortBy,
    required this.createdByEmployeeId,
    required this.search,
    required this.teamLeaderId,
    required this.startDateTime,
    required this.endDateTime,
  });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        sortDirection,
        sortBy,
        createdByEmployeeId,
        search,
        teamLeaderId,
        startDateTime,
        endDateTime,
      ];
}
