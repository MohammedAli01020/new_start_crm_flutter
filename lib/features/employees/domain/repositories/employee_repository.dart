import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/employee_filters_model.dart';
import '../../data/models/employee_model.dart';
import '../../data/models/role_model.dart';
import '../entities/employees_data.dart';
import '../use_cases/employee_use_cases.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, EmployeesData>> getAllEmployeesWithFilters(
      EmployeeFiltersModel employeeFiltersModel);

  Future<Either<Failure, EmployeeModel>> modifyEmployee(
      ModifyEmployeeParam modifyEmployeeParam);

  Future<Either<Failure, void>> deleteEmployee(int costId);

  Future<Either<Failure, RoleModel>> findRoleByEmployeeId(int employeeId);

  Future<Either<Failure, EmployeeModel>> getEmployeeById(int employeeId);


}
