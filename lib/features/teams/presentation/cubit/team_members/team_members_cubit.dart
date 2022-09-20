import 'package:crm_flutter_project/features/teams/data/models/team_member_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_members_filters_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/user_team_id_model.dart';
import 'package:crm_flutter_project/features/teams/domain/entities/user_teams_data.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_member_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/wrapper.dart';

part 'team_members_state.dart';

class TeamMembersCubit extends Cubit<TeamMembersState> {
  final TeamMemberUseCases teamMemberUseCases;

  TeamMembersCubit({required this.teamMemberUseCases})
      : super(TeamMembersInitial());

  static TeamMembersCubit get(context) => BlocProvider.of(context);

  TeamMembersFiltersModel teamMembersFiltersModel =
      TeamMembersFiltersModel.initial();

  void updateFilter(TeamMembersFiltersModel newFilter) {
    emit(StartUpdateFilter());
    teamMembersFiltersModel = newFilter;
    emit(EndUpdateFilter());
  }

  void resetFilter() {
    emit(StartResetFilter());
    teamMembersFiltersModel = TeamMembersFiltersModel.initial();
    emit(EndResetFilter());
  }

  List<TeamMemberModel> teamMembers = [];
  int teamMembersCurrentPage = 0;
  int teamMembersTotalElements = 0;
  late int teamMembersPagesCount;

  bool isNoMoreData = false;

  Future<void> fetchTeamMembers({bool refresh = false}) async {
    if (state is StartRefreshTeamMembers || state is StartLoadingTeamMembers) {
      return;
    }

    if (refresh) {
      teamMembersCurrentPage = 0;
      isNoMoreData = false;
      emit(StartRefreshTeamMembers());
    } else {
      if (teamMembersCurrentPage >= teamMembersPagesCount) {
        isNoMoreData = true;
        emit(LoadNoMoreTeamMembers());
        return;
      } else {
        emit(StartLoadingTeamMembers());
      }
    }

    Either<Failure, UserTeamsData> response = await teamMemberUseCases
        .getAllTeamMembersWithFilters(teamMembersFiltersModel.copyWith(
            pageNumber: Wrapped.value(teamMembersCurrentPage)));

    if (response.isRight()) {
      setTeamMembersData(
          result: response.getOrElse(() => throw Exception()),
          refresh: refresh);
    }

    if (refresh) {
      emit(response.fold(
          (failure) =>
              RefreshTeamMembersError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndRefreshTeamMembers()));
    } else {
      emit(response.fold(
          (failure) =>
              LoadingTeamMembersError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndLoadingTeamMembers()));
    }
  }

  void setTeamMembersData(
      {required UserTeamsData result, required bool refresh}) {
    List<TeamMemberModel> newTeamMembers = result.teamMembers;

    teamMembersCurrentPage++;

    teamMembersTotalElements = result.totalElements;
    teamMembersPagesCount = result.totalPages;
    if (refresh) {
      teamMembers = newTeamMembers;
    } else {
      teamMembers.addAll(newTeamMembers);
    }
  }

  List<int> selectedTeamMembersIds = [];

  void updateSelectedTeamMembersIds(int teamMemberId, bool val) {
    emit(StartUpdateSelectedTeamMembers());
    if (val) {
      selectedTeamMembersIds.add(teamMemberId);
    } else {
      selectedTeamMembersIds.remove(teamMemberId);
    }

    emit(EndUpdateSelectedTeamMembers());
  }

  void resetSelectedTeamMembers() {
    emit(StartResetSelectedTeamMembers());
    selectedTeamMembersIds = [];
    emit(EndResetSelectedTeamMembers());

  }

  Future<void> insertBulkTeamMembers(
      InsertBulkTeamMembersParam insertBulkTeamMembersParam) async {
    emit(StartInsertBulkTeamMembers());

    Either<Failure, List<TeamMemberModel>> response = await teamMemberUseCases
        .insertBulkTeamMembers(insertBulkTeamMembersParam);

    response.fold(
        (failure) => emit(InsertBulkTeamMembersError(
            msg: Constants.mapFailureToMsg(failure))),
            (newTeamMembers) {

      teamMembers.insertAll(0, newTeamMembers);
      teamMembersTotalElements = teamMembersTotalElements + newTeamMembers.length;

      return emit(EndInsertBulkTeamMembers(insertedTeamMembers: newTeamMembers));
    });
  }

  Future<void> fetchAllTeamMembersByTeamId(int teamId) async {

    emit(StartFetchAllTeamMembersByTeamId());
    Either<Failure, List<int>> response = await teamMemberUseCases.fetchAllTeamMembersByTeamId(teamId);


   response.fold((failure) => emit(FetchAllTeamMembersByTeamIdError(msg: Constants.mapFailureToMsg(failure))),
            (newAllTeamMembersIds) {
              selectedTeamMembersIds = newAllTeamMembersIds;
              return emit(EndFetchAllTeamMembersByTeamId(insertedTeamMembersId: newAllTeamMembersIds));
            });
  }


  Future<void> deleteAllTeamMembersByIds(List<UserTeamIdModel> userTeamIds) async {

    emit(StartDeleteAllTeamMembersByIds());


    Either<Failure, void> response = await teamMemberUseCases.deleteAllTeamMembersByIds(UserTeamIdsWrapper(userTeamIds: userTeamIds));


    response.fold((failure) => emit(DeleteAllTeamMembersByIdsError(msg: Constants.mapFailureToMsg(failure))),
            (v) {
              userTeamIds.map((userTeamId) {
                teamMembers.removeWhere((element) {
                  return element.employee.employeeId == userTeamId.employeeId;
                });


              });


              selectedTeamMembersIds = [];

              teamMembersTotalElements = teamMembersTotalElements - userTeamIds.length;
              return emit(EndDeleteAllTeamMembersByIds());
            });
  }

}
