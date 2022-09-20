import 'package:crm_flutter_project/features/teams/data/models/team_filters_model.dart';
import 'package:crm_flutter_project/features/teams/domain/entities/teams_data.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_use_cases.dart';
import 'package:flutter/material.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';
import '../../data/models/team_model.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  final TeamUseCases teamUseCases;

  TeamCubit({required this.teamUseCases}) : super(TeamInitial());

  static TeamCubit get(context) => BlocProvider.of(context);

  TeamFiltersModel teamFiltersModel = TeamFiltersModel.initial();

  void updateFilter(TeamFiltersModel newFilter) {
    emit(StartUpdateFilter());
    teamFiltersModel = newFilter;
    emit(EndUpdateFilter());
  }

  void resetFilter() {
    emit(StartResetFilter());
    teamFiltersModel = TeamFiltersModel.initial();
    emit(EndResetFilter());
  }

  List<TeamModel> teams = [];
  int teamCurrentPage = 0;
  int teamTotalElements = 0;
  late int teamPagesCount;

  bool isNoMoreData = false;


  void setCurrentPage(int index) {
    emit(StartChangeCurrentPage());
    teamCurrentPage = index;
    emit(EndChangeCurrentPage());
  }

  Future<void> fetchTeams({bool refresh = false, required bool isWebPagination}) async {
    if (state is StartRefreshTeams || state is StartLoadingTeams) {
      return;
    }

    if (refresh && isWebPagination) {
      isNoMoreData = false;
      emit(StartRefreshTeams());
    }
    
    if (refresh && !isWebPagination) {
      teamCurrentPage = 0;
      isNoMoreData = false;
      emit(StartRefreshTeams());
    } else if (!isWebPagination) {
      if (teamCurrentPage >= teamPagesCount) {
        isNoMoreData = true;
        emit(LoadNoMoreTeams());
        return;
      } else {
        emit(StartLoadingTeams());
      }
    }

    Either<Failure, TeamsData> response =
        await teamUseCases.getAllTeamsWithFilters(teamFiltersModel.copyWith(
            pageNumber: Wrapped.value(teamCurrentPage)));

    if (response.isRight()) {
      setTeamsData(
          result: response.getOrElse(() => throw Exception()),
          refresh: refresh, isWebPagination: isWebPagination);
    }

    if (refresh) {
      emit(response.fold(
          (failure) =>
              RefreshTeamsError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndRefreshTeams()));
    } else {
      emit(response.fold(
          (failure) =>
              LoadingTeamsError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndLoadingTeams()));
    }
  }

  void setTeamsData({required TeamsData result, required bool refresh,required bool isWebPagination}) {
    List<TeamModel> newTeams = result.teams;

    if (!isWebPagination) {
      teamCurrentPage++;
    }
   
    teamTotalElements = result.totalElements;
    teamPagesCount = result.totalPages;
    if (refresh) {
      teams = newTeams;
    } else {
      teams.addAll(newTeams);
    }
  }




  Future<void> deleteTeam(int teamId) async {
    emit(StartDeleteTeam());

    Either<Failure, void> response = await teamUseCases.deleteTeam(teamId);

    response.fold(
        (failure) =>
            emit(DeleteTeamError(msg: Constants.mapFailureToMsg(failure))),
        (success) {
      try {
        teams.removeWhere((element) {
          return element.teamId == teamId;
        });

        teamTotalElements--;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndDeleteTeam(teamId: teamId));
    });
  }

  Future<void> modifyTeam(ModifyTeamParam modifyTeamParam) async {
    emit(StartModifyTeam());
    Either<Failure, TeamModel> response =
        await teamUseCases.modifyTeam(modifyTeamParam);

    response.fold(
        (failure) =>
            emit(ModifyTeamError(msg: Constants.mapFailureToMsg(failure))),
        (newTeamModel) {
      if (modifyTeamParam.teamId != null) {
        try {
          int index = teams.indexWhere((team) {
            return team.teamId == modifyTeamParam.teamId;
          });

          teams[index] = newTeamModel;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        teams.insert(0, newTeamModel);
        teamTotalElements++;
      }

      return emit(EndModifyTeam(teamModel: newTeamModel));
    });
  }
}
