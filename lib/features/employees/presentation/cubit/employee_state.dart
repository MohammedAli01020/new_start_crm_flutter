part of 'employee_cubit.dart';

@immutable
abstract class EmployeeState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}


class StartUpdateFilter extends EmployeeState {}

class EndUpdateFilter extends EmployeeState {}

class StartResetFilter extends EmployeeState {}

class EndResetFilter extends EmployeeState {}

class StartRefreshEmployees extends EmployeeState {}

class EndRefreshEmployees extends EmployeeState {}

class RefreshEmployeesError extends EmployeeState {
  final String msg;

  RefreshEmployeesError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartLoadingEmployees extends EmployeeState {}

class EndLoadingEmployees extends EmployeeState {}

class LoadingEmployeesError extends EmployeeState {
  final String msg;

  LoadingEmployeesError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoadNoMoreEmployees extends EmployeeState {}

// modify

class StartModifyEmployee extends EmployeeState {}

class EndModifyEmployee extends EmployeeState {
  final EmployeeModel employeeModel;

  EndModifyEmployee({required this.employeeModel});

  @override
  List<Object> get props => [employeeModel];
}

class ModifyEmployeeError extends EmployeeState {
  final String msg;

  ModifyEmployeeError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteEmployee extends EmployeeState {}

class EndDeleteEmployee extends EmployeeState {
  final int employeeId;

  EndDeleteEmployee({required this.employeeId});

  @override
  List<Object> get props => [employeeId];
}

class DeleteEmployeeError extends EmployeeState {
  final String msg;

  DeleteEmployeeError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartUpdateRole extends EmployeeState {}

class EndUpdateRole extends EmployeeState {}


class StartUpdateCurrentEmployeeModel extends EmployeeState {}

class EndUpdateCurrentEmployeeModel extends EmployeeState {}


class StartFindRoleByEmployeeId extends EmployeeState {}

class EndFindRoleByEmployeeId extends EmployeeState {
  final RoleModel roleModel;

  EndFindRoleByEmployeeId({required this.roleModel});

  @override
  List<Object> get props => [roleModel];
}

class FindRoleByEmployeeIdError extends EmployeeState {
  final String msg;

  FindRoleByEmployeeIdError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class UploadImageFileError extends EmployeeState {
  final String msg;

  UploadImageFileError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartGetEmployeeById extends EmployeeState {}

class EndGetEmployeeById extends EmployeeState {
  final EmployeeModel employeeModel;

  EndGetEmployeeById({required this.employeeModel});

  @override
  List<Object> get props => [employeeModel];

}

class GetEmployeeByIdError extends EmployeeState {
  final String msg;

  GetEmployeeByIdError({required this.msg});

  @override
  List<Object> get props => [msg];

}
