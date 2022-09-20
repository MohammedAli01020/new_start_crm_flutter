import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/phoneNumber_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/employees/domain/entities/employees_data.dart';
import 'package:crm_flutter_project/features/employees/domain/repositories/employee_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/employee_filters_model.dart';

abstract class EmployeeUseCases {
  Future<Either<Failure, EmployeesData>> getAllEmployeesWithFilters(
      EmployeeFiltersModel employeeFiltersModel);

  Future<Either<Failure, EmployeeModel>> modifyEmployee(
      ModifyEmployeeParam modifyEmployeeParam);

  Future<Either<Failure, void>> deleteEmployee(int costId);
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
}

class ModifyEmployeeParam {
  final int? employeeId;

  final String fullName;

  final String? imageUrl;

  final int createDateTime;

  final PhoneNumberModel phoneNumber;

  final bool enabled;

  final String username;

  final String? password;

  final RoleModel? role;

  final int? createdByEmployeeId;

  ModifyEmployeeParam(
      {required this.employeeId,
      required this.fullName,
      required this.imageUrl,
      required this.createDateTime,
      required this.phoneNumber,
      required this.enabled,
      required this.username,
      required this.password,
      required this.role,
      required this.createdByEmployeeId});

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "fullName": fullName,
        "imageUrl": imageUrl,
        "createDateTime": createDateTime,
        "phoneNumber": phoneNumber.toJson(),
        "enabled": enabled,
        "username": username,
        "password": password,
        "role": role?.toJson(),
        "createdByEmployeeId": createdByEmployeeId,
      };
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

