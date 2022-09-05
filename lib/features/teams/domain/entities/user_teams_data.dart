import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_member_model.dart';
import 'package:equatable/equatable.dart';

class UserTeamsData extends Equatable {
  const UserTeamsData({
    required this.teamMembers,
    required this.pageable,
    required this.last,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.sort,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  final List<TeamMemberModel> teamMembers;
  final PageableModel pageable;
  final bool last;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;
  final SortModel sort;
  final bool first;
  final int numberOfElements;
  final bool empty;

  @override
  List<Object> get props => [
        teamMembers,
        pageable,
        last,
        totalPages,
        totalElements,
        size,
        number,
        sort,
        first,
        numberOfElements,
        empty,
      ];
}
