import 'package:crm_flutter_project/features/developers_and_projects/data/models/developer_model.dart';
import 'package:crm_flutter_project/features/developers_and_projects/domain/use_cases/developer_use_case.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants.dart';
part 'developer_state.dart';

class DeveloperCubit extends Cubit<DeveloperState> {
  final DeveloperUseCase developerUseCase;
  DeveloperCubit({required this.developerUseCase}) : super(DeveloperInitial());

  static DeveloperCubit get(context) => BlocProvider.of(context);

  List<DeveloperModel> developers = [];
  List<DeveloperModel> filteredDevelopers = [];



  // developers
  List<String> selectedDevelopersNames = [];


  void updateSelectedDevelopers(String developerName) {
    emit(StartUpdateSelectedDevelopers());
    if (selectedDevelopersNames.contains(developerName)) {
      selectedDevelopersNames.remove(developerName);
    } else {
      selectedDevelopersNames.add(developerName);
    }
    emit(EndUpdateSelectedDevelopers());
  }



  void addDeveloperName(String developerName) {
    emit(StartAddDeveloperName());
    if (!selectedDevelopersNames.contains(developerName)) {
      selectedDevelopersNames.add(developerName);
    }
    emit(EndAddDeveloperName());
  }

  void removeDeveloperName(String developerName) {
    emit(StartRemoveDeveloperName());

    if (selectedDevelopersNames.contains(developerName)) {
      selectedDevelopersNames.remove(developerName);
    }
    emit(EndRemoveDeveloperName());

  }


  void setSelectedDevelopers(List<String> newSources) {
    emit(StartAddDeveloperName());
    selectedDevelopersNames = newSources;
    emit(StartAddDeveloperName());
  }



  // projects
  List<String> selectedProjectsNames = [];

  void setSelectedProjects(List<String> newProjects) {
    emit(StartUpdateSelectedProjects());
    selectedProjectsNames = newProjects;
    emit(EndUpdateSelectedProjects());
  }

  void updateSelectedProjects(String projectName) {
    emit(StartUpdateSelectedProjects());
    if (selectedProjectsNames.contains(projectName)) {
      selectedProjectsNames.remove(projectName);
    } else {
      selectedProjectsNames.add(projectName);
    }
    emit(EndUpdateSelectedProjects());
  }



  void filterDevelopers(String name) {
    emit(StartFilterDevelopers());

    if (name.isNotEmpty) {

      if (filteredDevelopers.isEmpty) {
        filteredDevelopers = developers;
      }

      filteredDevelopers = filteredDevelopers.where((element) {
        return element.name.toLowerCase().contains(name.toLowerCase());
      }).toList();


    } else {
      filteredDevelopers = developers;
    }

    emit(EndFilterDevelopers());

  }

  void resetFilters() {
    emit(StartResetFilters());
    filteredDevelopers = developers;
    emit(EndResetFilters());

  }

  Future<void> getAllDevelopersByNameLike({String? name}) async {
    emit(StartGetAllDevelopersByNameLike());

    Either<Failure, List<DeveloperModel>> response =
    await developerUseCase.getAllDevelopersByNameLike(name: name);

    response.fold(
            (failure) => emit(GetAllDevelopersByNameLikeError(
            msg: Constants.mapFailureToMsg(failure))), (fetchedDevelopers) {
      developers = fetchedDevelopers;
      filteredDevelopers = fetchedDevelopers;
      return emit(EndGetAllDevelopersByNameLike(fetchedDevelopers: fetchedDevelopers));
    });
  }

  Future<void> modifyDeveloper(ModifyDeveloperParam modifyDeveloperParam) async {

    emit(StartModifyDeveloper());

    Either<Failure, DeveloperModel> response =
    await developerUseCase.modifyDeveloper(modifyDeveloperParam);

    response.fold(
            (failure) => emit(ModifyDeveloperError(
            msg: Constants.mapFailureToMsg(failure))), (modifiedDeveloper) {

      if (modifyDeveloperParam.developerId != null) {
        try {
          int index = developers.indexWhere((element) {
            return element.developerId == modifyDeveloperParam.developerId;
          });

          developers[index] = modifiedDeveloper;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        developers.insert(0, modifiedDeveloper);
      }

      return emit(EndModifyDeveloper(modifiedDeveloper: modifiedDeveloper));
    });

  }

  Future<void> deleteDeveloper(int eventId) async {

    emit(StartDeleteDeveloper());

    Either<Failure, void> response =
    await developerUseCase.deleteDeveloper(eventId);

    response.fold((failure) => emit(DeleteDeveloperError(msg: Constants.mapFailureToMsg(failure))),
            (success) {

          try {
            developers.removeWhere((element) {
              return element.developerId == eventId;
            });
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndDeleteDeveloper(developerId: eventId));
        });
  }
}
