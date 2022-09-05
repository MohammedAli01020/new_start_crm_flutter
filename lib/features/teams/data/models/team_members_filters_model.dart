import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/team_members_filters.dart';

class TeamMembersFiltersModel extends TeamMembersFilters {
  const TeamMembersFiltersModel({
    required int pageNumber,
    required int pageSize,
    required String sortDirection,
    required String sortBy,
    required int teamId,
  }) : super(
            pageNumber: pageNumber,
            pageSize: pageSize,
            sortDirection: sortDirection,
            sortBy: sortBy,
            teamId: teamId);

  factory TeamMembersFiltersModel.fromJson(Map<String, dynamic> json) =>
      TeamMembersFiltersModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        sortDirection: json["sortDirection"],
        sortBy: json["sortBy"],
        teamId: json["teamId"],
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "sortDirection": sortDirection,
        "sortBy": sortBy,
        "teamId": teamId,
      };

  TeamMembersFiltersModel copyWith({
    Wrapped<int>? pageNumber,
    Wrapped<int>? pageSize,
    Wrapped<String>? sortDirection,
    Wrapped<String>? sortBy,
    Wrapped<int>? teamId,
  }) {
    return TeamMembersFiltersModel(
      pageNumber: pageNumber != null ? pageNumber.value : this.pageNumber,
      pageSize: pageSize != null ? pageSize.value : this.pageSize,
      sortDirection:
          sortDirection != null ? sortDirection.value : this.sortDirection,
      sortBy: sortBy != null ? sortBy.value : this.sortBy,
      teamId: teamId != null ? teamId.value : this.teamId,
    );
  }

  factory TeamMembersFiltersModel.initial() {
    return const TeamMembersFiltersModel(
      pageNumber: 0,
      pageSize: 10,
      sortDirection: "DESC",
      sortBy: "insertDateTime",
      teamId: -1,
    );
  }
}
