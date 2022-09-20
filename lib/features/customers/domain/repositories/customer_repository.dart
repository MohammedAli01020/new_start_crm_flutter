import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../employees/data/models/phoneNumber_model.dart';
import '../../data/models/customer_filters_model.dart';
import '../../data/models/customer_model.dart';
import '../entities/customers_data.dart';
import '../use_cases/customer_use_cases.dart';
abstract class CustomerRepository {
  Future<Either<Failure, CustomersData>> getAllCustomersWithFilters(
      CustomerFiltersModel customerFiltersModel);

  Future<Either<Failure, CustomerModel>> modifyCustomer(
      ModifyCustomerParam modifyCustomerParam);

  Future<Either<Failure, void>> deleteCustomer(int customerId);

  Future<Either<Failure, CustomerModel>> updateCustomerLastAction(
      UpdateCustomerLastActionParam updateCustomerLastActionParam);

  Future<Either<Failure, List<CustomerModel>>> updateBulkCustomers(
      UpdateCustomerParam updateCustomerParam);

  Future<Either<Failure, CustomerModel>> updateCustomerFullName(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam);

  Future<Either<Failure, List<CustomerModel>>> findDistinctCustomersByPhoneNumber(
      PhoneNumberModel phoneNumberModel);

  Future<Either<Failure, CustomerModel>> updateCustomerDescription(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam);

  Future<Either<Failure, CustomerModel>> updateCustomerSources(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam);

  Future<Either<Failure, CustomerModel>> updateCustomerUnitTypes(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam);


  Future<Either<Failure, CustomerModel>> updateCustomerAssignedEmployee(
      UpdateCustomerAssignedEmployeeParam updateCustomerAssignedEmployeeParam);

  Future<Either<Failure, CustomerModel>> deleteCustomerAssignedEmployee(
      DeleteCustomerAssignedEmployeeParam deleteCustomerAssignedEmployeeParam);
}