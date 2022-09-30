
import 'package:crm_flutter_project/features/employees/domain/entities/employee.dart';
import 'package:crm_flutter_project/features/login/domain/entities/current_employee.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

import '../../../customer_table_config/data/models/customer_table_config_model.dart';
import '../../../employees/data/models/role_model.dart';
import '../use_cases/login_use_cases.dart';

abstract class LoginRepository {
  Future<Either<Failure, CurrentEmployee>> login(LoginParam loginParam);
  Future<Either<Failure, CurrentEmployee>> getSavedCurrentEmployee();
  Future<Either<Failure, Employee>> getEmployeeById(int employerId);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, CustomerTableConfigModel>> loadLastCustomerTableConfig();

  Future<Either<Failure, RoleModel>> findRoleByEmployeeId(int employeeId);
}