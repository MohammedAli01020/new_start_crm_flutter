import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../employees/domain/entities/employee.dart';
import '../../domain/entities/current_employee.dart';
import '../../domain/repositories/login_repository.dart';
import '../../domain/use_cases/login_use_cases.dart';
import '../data_sources/login_local_data_source.dart';
import '../data_sources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  final LoginLocalDataSource loginLocalDataSource;

  LoginRepositoryImpl({
    required this.loginRemoteDataSource,
    required this.loginLocalDataSource,
  });

  @override
  Future<Either<Failure, CurrentEmployee>> login(LoginParam loginParam) async {
    try {
      final currentEmployeeModel =
          await loginRemoteDataSource.login(loginParam);
      // then save it to shared prefs
      loginLocalDataSource.cacheCurrentEmployee(currentEmployeeModel);
      Constants.currentEmployee = currentEmployeeModel;
      return Right(currentEmployeeModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    } on CacheException catch (e) {
      return Left(CacheFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CurrentEmployee>> getSavedCurrentEmployee() async {
    try {
      final currentEmployerModel =
          await loginLocalDataSource.getCacheEmployee();
      return Right(currentEmployerModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, Employee>> getEmployeeById(int employerId) async {
    try {
      final employerModel =
          await loginRemoteDataSource.getEmployeeById(employerId);
      return Right(employerModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final response = await loginLocalDataSource.removeCacheCurrentEmployee();
      Constants.currentEmployee = null;

      return Right(response);
    } on CacheException catch (e) {
      return Left(CacheFailure(msg: e.msg));
    }
  }
}
