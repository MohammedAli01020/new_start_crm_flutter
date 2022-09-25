part of 'developer_cubit.dart';

@immutable
abstract class DeveloperState extends Equatable {
  @override
  List<Object> get props => [];
}

class DeveloperInitial extends DeveloperState {}


class StartGetAllDevelopersByNameLike extends DeveloperState {}

class EndGetAllDevelopersByNameLike extends DeveloperState {

  final List<DeveloperModel> fetchedDevelopers;
  EndGetAllDevelopersByNameLike({required this.fetchedDevelopers});

  @override
  List<Object> get props => [fetchedDevelopers];
}

class GetAllDevelopersByNameLikeError extends DeveloperState {

  final String msg;
  GetAllDevelopersByNameLikeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartModifyDeveloper extends DeveloperState {}
class EndModifyDeveloper extends DeveloperState {
  final DeveloperModel modifiedDeveloper;
  EndModifyDeveloper({required this.modifiedDeveloper});

  @override
  List<Object> get props => [modifiedDeveloper];
}
class ModifyDeveloperError extends DeveloperState {
  final String msg;
  ModifyDeveloperError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteDeveloper extends DeveloperState {}
class EndDeleteDeveloper extends DeveloperState {
  final int developerId;
  EndDeleteDeveloper({required this.developerId});

  @override
  List<Object> get props => [developerId];
}
class DeleteDeveloperError extends DeveloperState {
  final String msg;
  DeleteDeveloperError({required this.msg});

  @override
  List<Object> get props => [msg];
}



class StartFilterDevelopers extends DeveloperState {}
class EndFilterDevelopers extends DeveloperState {}


class StartResetFilters extends DeveloperState {}
class EndResetFilters extends DeveloperState {}



class StartAddDeveloperName extends DeveloperState {}
class EndAddDeveloperName extends DeveloperState {}

class StartRemoveDeveloperName extends DeveloperState {}
class EndRemoveDeveloperName extends DeveloperState {}


class StartUpdateSelectedProjects extends DeveloperState {}
class EndUpdateSelectedProjects extends DeveloperState {}


class StartUpdateSelectedDevelopers extends DeveloperState {}
class EndUpdateSelectedDevelopers  extends DeveloperState {}