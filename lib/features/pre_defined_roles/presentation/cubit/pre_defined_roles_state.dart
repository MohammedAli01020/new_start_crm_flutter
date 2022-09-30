part of 'pre_defined_roles_cubit.dart';

@immutable
abstract class PreDefinedRolesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PreDefinedRolesInitial extends PreDefinedRolesState {}


class StartGetAllPreDefinedRoles extends PreDefinedRolesState {}

class EndGetAllPreDefinedRoles extends PreDefinedRolesState {

  final List<RoleModel> fetchedRoles;
  EndGetAllPreDefinedRoles({required this.fetchedRoles});

  @override
  List<Object> get props => [fetchedRoles];
}

class GetAllPreDefinedRolesError extends PreDefinedRolesState {

  final String msg;
  GetAllPreDefinedRolesError({required this.msg});

  @override
  List<Object> get props => [msg];
}





class StartModifyPredefinedRole extends PreDefinedRolesState {}
class EndModifyPredefinedRole  extends PreDefinedRolesState {
  final RoleModel predefinedRole;
  EndModifyPredefinedRole({required this.predefinedRole});

  @override
  List<Object> get props => [predefinedRole];
}
class ModifyPredefinedRoleError extends PreDefinedRolesState {
  final String msg;
  ModifyPredefinedRoleError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeletePredefinedRole extends PreDefinedRolesState {}
class EndDeletePredefinedRole extends PreDefinedRolesState {
  final int predefinedRoleId;
  EndDeletePredefinedRole({required this.predefinedRoleId});

  @override
  List<Object> get props => [predefinedRoleId];
}
class DeletePredefinedRoleError extends PreDefinedRolesState {
  final String msg;
  DeletePredefinedRoleError({required this.msg});

  @override
  List<Object> get props => [msg];
}



class StartUpdateSelectedPermissionsRole extends PreDefinedRolesState {}
class EndUpdateSelectedPermissionsRole  extends PreDefinedRolesState {}