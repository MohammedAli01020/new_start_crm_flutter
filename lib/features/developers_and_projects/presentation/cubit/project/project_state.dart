part of 'project_cubit.dart';

@immutable
abstract class ProjectState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}


class StartGetAllProjectsWithFilters extends ProjectState {}

class EndGetAllProjectsWithFilters  extends ProjectState {

  final List<ProjectModel> fetchedProjects;
  EndGetAllProjectsWithFilters({required this.fetchedProjects});

  @override
  List<Object> get props => [fetchedProjects];
}

class GetAllProjectsWithFiltersError extends ProjectState {

  final String msg;
  GetAllProjectsWithFiltersError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartModifyProject extends ProjectState {}
class EndModifyProject extends ProjectState {
  final ProjectModel modifiedProject;
  EndModifyProject({required this.modifiedProject});

  @override
  List<Object> get props => [modifiedProject];
}
class ModifyProjectError extends ProjectState {
  final String msg;
  ModifyProjectError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteProject extends ProjectState {}
class EndDeleteProject extends ProjectState {
  final int projectId;
  EndDeleteProject({required this.projectId});

  @override
  List<Object> get props => [projectId];
}
class DeleteProjectError extends ProjectState {
  final String msg;
  DeleteProjectError({required this.msg});

  @override
  List<Object> get props => [msg];
}



class StartResetFilters extends ProjectState {}
class EndResetFilters extends ProjectState {}

class StartFilterProjects extends ProjectState {}
class EndFilterProjects extends ProjectState {}


class StartUpdateSelectedProjectsNames extends ProjectState {}
class EndUpdateSelectedProjectsNames  extends ProjectState {}