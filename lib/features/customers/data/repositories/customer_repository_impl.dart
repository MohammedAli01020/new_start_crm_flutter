import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/customers/data/data_sources/customer_remote_data_source.dart';

import 'package:crm_flutter_project/features/customers/data/models/customer_filters_model.dart';

import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';

import 'package:crm_flutter_project/features/customers/domain/entities/customers_data.dart';

import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:crm_flutter_project/features/employees/data/models/phoneNumber_model.dart';
import 'package:crm_flutter_project/features/login/data/data_sources/login_local_data_source.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource customerRemoteDataSource;
  final LoginLocalDataSource loginLocalDataSource;

  CustomerRepositoryImpl( {required this.customerRemoteDataSource,
    required this.loginLocalDataSource,});

  @override
  Future<Either<Failure, void>> deleteCustomer(int customerId) async {
    try {
      final response = await customerRemoteDataSource.deleteCustomer(customerId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomersData>> getAllCustomersWithFilters(CustomerFiltersModel customerFiltersModel) async {
    try {
      final response = await customerRemoteDataSource.getAllCustomersWithFilters(customerFiltersModel);
      return Right(response);
    } on ServerException catch (e) {
      // if (e is InternalServerErrorException) {
      //   loginLocalDataSource.removeCacheCurrentEmployee();
      // }
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> modifyCustomer(ModifyCustomerParam modifyCustomerParam) async {
    try {
      final response = await customerRemoteDataSource.modifyCustomer(modifyCustomerParam);
      return Right(response);
    } on ServerException catch (e) {


      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerLastAction(UpdateCustomerLastActionParam updateCustomerLastActionParam) async {
    try {
      final response = await customerRemoteDataSource.updateCustomerLastAction(updateCustomerLastActionParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<CustomerModel>>> updateBulkCustomers(UpdateCustomerParam updateCustomerParam) async {
    try {
      final response = await customerRemoteDataSource.updateBulkCustomers(updateCustomerParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerFullName(UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam) async {
    try {
      final response = await customerRemoteDataSource.updateCustomerFullName(updateCustomerNameOrDescParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<CustomerModel>>> findDistinctCustomersByPhoneNumber(PhoneNumberModel phoneNumberModel) async {
    try {
      final response = await customerRemoteDataSource.findDistinctCustomersByPhoneNumber(phoneNumberModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerDescription(UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam) async {
    try {
      final response = await customerRemoteDataSource.updateCustomerDescription(updateCustomerNameOrDescParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerSources(UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) async {
    try {
      final response = await customerRemoteDataSource.updateCustomerSources(updateCustomerSourcesOrUnitTypesParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerUnitTypes(UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) async {
    try {
      final response = await customerRemoteDataSource.updateCustomerUnitTypes(updateCustomerSourcesOrUnitTypesParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> deleteCustomerAssignedEmployee(DeleteCustomerAssignedEmployeeParam deleteCustomerAssignedEmployeeParam) async {
    try {
      final response = await customerRemoteDataSource.deleteCustomerAssignedEmployee(deleteCustomerAssignedEmployeeParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerAssignedEmployee(UpdateCustomerAssignedEmployeeParam updateCustomerAssignedEmployeeParam) async {
    try {
      final response = await customerRemoteDataSource.updateCustomerAssignedEmployee(updateCustomerAssignedEmployeeParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerPhoneNumber(UpdateCustomerPhoneNumberParam updateCustomerPhoneNumberParam) async {
    try {
      final response = await customerRemoteDataSource.updateCustomerPhoneNumber(updateCustomerPhoneNumberParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}