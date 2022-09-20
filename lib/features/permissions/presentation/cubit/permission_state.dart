part of 'permission_cubit.dart';

@immutable
abstract class PermissionState extends Equatable{

  @override
  List<Object?> get props => [];
}

class PermissionInitial extends PermissionState {}



class StartGetAllPermissionsByNameLike extends PermissionState {}

class EndGetAllPermissionsByNameLike extends PermissionState {

  final List<PermissionModel> fetchedPermissions;
  EndGetAllPermissionsByNameLike({required this.fetchedPermissions});

  @override
  List<Object> get props => [fetchedPermissions];
}

class GetAllPermissionsByNameLikeError extends PermissionState {

  final String msg;
  GetAllPermissionsByNameLikeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartUpdateSelectedPermissions extends PermissionState {}
class EndUpdateSelectedPermissions extends PermissionState {}


class StartUpdateAllPermissions extends PermissionState {}
class EndUpdateAllPermissions extends PermissionState {}

