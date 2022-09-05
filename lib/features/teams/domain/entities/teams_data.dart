import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_model.dart';
import 'package:equatable/equatable.dart';

class TeamsData extends Equatable {
  const TeamsData({
    required this.teams,
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

  final List<TeamModel> teams;
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
  List<Object> get props =>
      [
        teams,
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
