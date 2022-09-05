import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/employees/data/data_sources/employee_remote_data_source.dart';

import 'package:crm_flutter_project/features/employees/data/models/employee_filters_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';

import 'package:crm_flutter_project/features/employees/domain/entities/employees_data.dart';

import 'package:crm_flutter_project/features/employees/domain/use_cases/employee_use_cases.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource employeeRemoteDataSource;

  EmployeeRepositoryImpl({required this.employeeRemoteDataSource});
  @override
  Future<Either<Failure, void>> deleteEmployee(int costId) async {
    try {
      final response = await employeeRemoteDataSource.deleteEmployee(costId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, EmployeesData>> getAllEmployeesWithFilters(EmployeeFiltersModel employeeFiltersModel) async {
    try {
      final response = await employeeRemoteDataSource.getAllEmployeesWithFilters(employeeFiltersModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> modifyEmployee(ModifyEmployeeParam modifyEmployeeParam) async {
    try {
      final response = await employeeRemoteDataSource.modifyEmployee(modifyEmployeeParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }



}