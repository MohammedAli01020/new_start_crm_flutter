
import 'package:crm_flutter_project/features/employees/domain/entities/employee.dart';
import 'package:crm_flutter_project/features/login/domain/entities/current_employee.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../customer_table_config/data/models/customer_table_config_model.dart';
import '../repositories/login_repository.dart';

abstract class LoginUseCases {
  Future<Either<Failure, CurrentEmployee>> login(LoginParam loginParam);

  Future<Either<Failure, CurrentEmployee>> getSavedCurrentEmployee();

  Future<Either<Failure, Employee>> getEmployeeById(int employeeId);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, CustomerTableConfigModel>> loadLastCustomerTableConfig();

}

class LoginUseCasesImpl implements LoginUseCases {

  final LoginRepository loginRepository;
  LoginUseCasesImpl({required this.loginRepository});

  @override
  Future<Either<Failure, CurrentEmployee>> login(LoginParam loginParam) {
    return loginRepository.login(loginParam);
  }

  @override
  Future<Either<Failure, CurrentEmployee>> getSavedCurrentEmployee() {
    return loginRepository.getSavedCurrentEmployee();
  }

  @override
  Future<Either<Failure, Employee>> getEmployeeById(int employeeId) {
    return loginRepository.getEmployeeById(employeeId);
  }

  @override
  Future<Either<Failure, void>> logout() {
    return loginRepository.logout();
  }

  @override
  Future<Either<Failure, CustomerTableConfigModel>> loadLastCustomerTableConfig() {
    return loginRepository.loadLastCustomerTableConfig();
  }


}


class LoginParam extends Equatable {

  final String username;
  final String password;

  const LoginParam({required this.username, required this.password});


  factory LoginParam.fromJson(Map<String, dynamic> json) =>
      LoginParam(
        username: json["username"],
        password: json["password"]
      );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password
  };

  @override
  List<Object> get props => [username, password];
}
