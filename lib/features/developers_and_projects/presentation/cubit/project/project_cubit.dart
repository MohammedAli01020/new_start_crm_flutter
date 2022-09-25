import 'package:crm_flutter_project/features/developers_and_projects/domain/use_cases/projects_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants.dart';
import '../../../data/models/project_model.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final ProjectUseCase projectUseCase;

  ProjectCubit({required this.projectUseCase}) : super(ProjectInitial());

  static ProjectCubit get(context) => BlocProvider.of(context);

  List<ProjectModel> projects = [];
  List<ProjectModel> filteredProjects = [];

  // projects
  List<String> selectedProjectsNames = [];

  void setSelectedProjects(List<String> newProjects) {
    emit(StartUpdateSelectedProjectsNames());
    selectedProjectsNames = newProjects;
    emit(EndUpdateSelectedProjectsNames());
  }

  void updateSelectedProjects(String projectName) {
    emit(StartUpdateSelectedProjectsNames());
    if (selectedProjectsNames.contains(projectName)) {
      selectedProjectsNames.remove(projectName);
    } else {
      selectedProjectsNames.add(projectName);
    }
    emit(EndUpdateSelectedProjectsNames());
  }

  void filterProjects(String name) {
    emit(StartFilterProjects());
    filteredProjects = filteredProjects.where((element) {
      return element.name.toLowerCase().contains(name.toLowerCase());
    }).toList();

    emit(EndFilterProjects());
  }

  void resetFilters() {
    emit(StartResetFilters());
    filteredProjects = projects;
    emit(EndResetFilters());
  }

  Future<void> getAllProjectsWithFilters(ProjectFilters projectFilters) async {
    emit(StartGetAllProjectsWithFilters());

    Either<Failure, List<ProjectModel>> response =
        await projectUseCase.getAllProjectsWithFilters(projectFilters);

    response.fold(
        (failure) => emit(GetAllProjectsWithFiltersError(
            msg: Constants.mapFailureToMsg(failure))), (fetchedProjects) {
      projects = fetchedProjects;
      filteredProjects = fetchedProjects;
      return emit(
          EndGetAllProjectsWithFilters(fetchedProjects: fetchedProjects));
    });
  }

  Future<void> modifyProject(ModifyProjectParam modifyProjectParam) async {
    emit(StartModifyProject());

    Either<Failure, ProjectModel> response =
        await projectUseCase.modifyProject(modifyProjectParam);

    response.fold(
        (failure) =>
            emit(ModifyProjectError(msg: Constants.mapFailureToMsg(failure))),
        (modifiedProject) {
      if (modifyProjectParam.projectId != null) {
        try {
          int index = projects.indexWhere((element) {
            return element.projectId == modifyProjectParam.projectId;
          });

          projects[index] = modifiedProject;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        projects.insert(0, modifiedProject);
      }

      return emit(EndModifyProject(modifiedProject: modifiedProject));
    });
  }

  Future<void> deleteProject(int projectId) async {
    emit(StartDeleteProject());

    Either<Failure, void> response =
        await projectUseCase.deleteProject(projectId);

    response.fold(
        (failure) =>
            emit(DeleteProjectError(msg: Constants.mapFailureToMsg(failure))),
        (success) {
      try {
        projects.removeWhere((element) {
          return element.projectId == projectId;
        });
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndDeleteProject(projectId: projectId));
    });
  }
}
