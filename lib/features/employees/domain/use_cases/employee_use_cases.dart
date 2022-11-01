import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/employees/domain/entities/employees_data.dart';
import 'package:crm_flutter_project/features/employees/domain/repositories/employee_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/wrapper.dart';
import '../../data/models/employee_filters_model.dart';

abstract class EmployeeUseCases {

  Future<Either<Failure, EmployeesData>> getAllEmployeesWithFilters(
      EmployeeFiltersModel employeeFiltersModel);

  Future<Either<Failure, EmployeeModel>> modifyEmployee(
      ModifyEmployeeParam modifyEmployeeParam);

  Future<Either<Failure, void>> deleteEmployee(int costId);

  Future<Either<Failure, RoleModel>> findRoleByEmployeeId(int employeeId);

  Future<Either<Failure, EmployeeModel>> getEmployeeById(int employeeId);


}

class EmployeeUseCasesImpl implements EmployeeUseCases {
  final EmployeeRepository employeeRepository;

  EmployeeUseCasesImpl({required this.employeeRepository});

  @override
  Future<Either<Failure, void>> deleteEmployee(int costId) {
    return employeeRepository.deleteEmployee(costId);
  }

  @override
  Future<Either<Failure, EmployeesData>> getAllEmployeesWithFilters(
      EmployeeFiltersModel employeeFiltersModel) {
    return employeeRepository.getAllEmployeesWithFilters(employeeFiltersModel);
  }

  @override
  Future<Either<Failure, EmployeeModel>> modifyEmployee(
      ModifyEmployeeParam modifyEmployeeParam) {
    return employeeRepository.modifyEmployee(modifyEmployeeParam);
  }

  @override
  Future<Either<Failure, RoleModel>> findRoleByEmployeeId(int employeeId) {
    return employeeRepository.findRoleByEmployeeId(employeeId);
  }

  @override
  Future<Either<Failure, EmployeeModel>> getEmployeeById(int employeeId) {
    return employeeRepository.getEmployeeById(employeeId);

  }

}

class ModifyEmployeeParam {
  final int? employeeId;

  final String fullName;

  final String? imageUrl;

  final int createDateTime;

  final String phoneNumber;

  final bool enabled;

  final String username;

  final String? password;

  final RoleModel? role;

  final int? createdByEmployeeId;


  ModifyEmployeeParam({required this.employeeId,
    required this.fullName,
    required this.imageUrl,
    required this.createDateTime,
    required this.phoneNumber,
    required this.enabled,
    required this.username,
    required this.password,
    required this.role,
    required this.createdByEmployeeId});

  Map<String, dynamic> toJson() =>
      {
        "employeeId": employeeId,
        "fullName": fullName,
        "imageUrl": imageUrl,
        "createDateTime": createDateTime,
        "phoneNumber": phoneNumber,
        "enabled": enabled,
        "username": username,
        "password": password,
        "role": role?.toJson(),
        "createdByEmployeeId": createdByEmployeeId,
      };

  ModifyEmployeeParam copyWith({
    Wrapped<int?>? employeeId,

    Wrapped<String>? fullName,

    Wrapped<String?>? imageUrl,

    Wrapped<int>? createDateTime,

    Wrapped<String>? phoneNumber,

    Wrapped<bool>? enabled,

    Wrapped<String>? username,

    Wrapped<String?>? password,

    Wrapped<RoleModel?>? role,

    Wrapped<int?>? createdByEmployeeId

  }) {
    return ModifyEmployeeParam(
        employeeId: employeeId != null ? employeeId.value : this.employeeId,
        fullName: fullName != null ? fullName.value : this.fullName,
        imageUrl: imageUrl != null ? imageUrl.value : this.imageUrl,
        createDateTime: createDateTime != null ? createDateTime.value : this.createDateTime,
        phoneNumber: phoneNumber != null ? phoneNumber.value : this.phoneNumber,
        enabled: enabled != null ? enabled.value : this.enabled,
        username: username != null ? username.value : this.username,
        password: password != null ? password.value : this.password,
        role: role != null ? role.value : this.role,
        createdByEmployeeId: createdByEmployeeId != null ? createdByEmployeeId.value : this.createdByEmployeeId);
  }


}


// class CreateRoleRequest {
//
//   final int? roleId;
//
//
//   final String name;
//
//   final List<int> permissionsIds;
//
//   CreateRoleRequest({this.roleId, required this.name, required this.permissionsIds});
//   Map<String, dynamic> toJson() => {
//     "employeeId": roleId,
//     "name": name,
//     "permissionsIds": permissionsIds,
//
//   };
//
// }

