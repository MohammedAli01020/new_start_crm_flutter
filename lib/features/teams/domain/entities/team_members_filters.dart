import 'package:equatable/equatable.dart';

class TeamMembersFilters extends Equatable {
  final int pageNumber;
  final int pageSize;
  final String sortDirection;
  final String sortBy;
  final int teamId;

  const TeamMembersFilters({
    required this.pageNumber,
    required this.pageSize,
    required this.sortDirection,
    required this.sortBy,
    required this.teamId,

  });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        sortDirection,
        sortBy,
        teamId
      ];
}
