import 'package:crm_flutter_project/features/customers/data/models/customers_data_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../employees/data/models/phoneNumber_model.dart';
import '../../domain/use_cases/customer_use_cases.dart';
import '../models/customer_filters_model.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomersDataModel> getAllCustomersWithFilters(
      CustomerFiltersModel customerFiltersModel);

  Future<CustomerModel> modifyCustomer(
      ModifyCustomerParam modifyCustomerParam);

  Future<void> deleteCustomer(int customerId);

  Future<CustomerModel> updateCustomerLastAction(
      UpdateCustomerLastActionParam updateCustomerLastActionParam);

  Future<List<CustomerModel>> updateBulkCustomers(
      UpdateCustomerParam updateCustomerParam);

  Future<CustomerModel> updateCustomerFullName(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam);

  Future<List<CustomerModel>> findDistinctCustomersByPhoneNumber(
      PhoneNumberModel phoneNumberModel);

  Future<CustomerModel> updateCustomerDescription(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam);

  Future<CustomerModel> updateCustomerSources(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam);


  Future<CustomerModel> updateCustomerUnitTypes(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam);


  Future<CustomerModel> updateCustomerAssignedEmployee(
      UpdateCustomerAssignedEmployeeParam updateCustomerAssignedEmployeeParam);

  Future<CustomerModel> deleteCustomerAssignedEmployee(
      DeleteCustomerAssignedEmployeeParam deleteCustomerAssignedEmployeeParam);
}
class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final ApiConsumer apiConsumer;

  CustomerRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteCustomer(int customerId) async {
    return await apiConsumer.delete(
      EndPoints.deleteCustomer + customerId.toString(),
    );
  }

  @override
  Future<CustomersDataModel> getAllCustomersWithFilters(CustomerFiltersModel customerFiltersModel) async {
    final response = await apiConsumer.get(EndPoints.pageCustomer,
        queryParameters: customerFiltersModel.toJson());

    return CustomersDataModel.fromJson(response);
  }

  @override
  Future<CustomerModel> modifyCustomer(ModifyCustomerParam modifyCustomerParam) async {
    final response = await apiConsumer.post(EndPoints.modifyCustomer,
        body: modifyCustomerParam.toJson());

    return CustomerModel.fromJson(response);
  }

  @override
  Future<CustomerModel> updateCustomerLastAction(UpdateCustomerLastActionParam updateCustomerLastActionParam) async {
    final response = await apiConsumer.put(EndPoints.updateCustomerLastAction,
        body: updateCustomerLastActionParam.toJson());

    return CustomerModel.fromJson(response);
  }

  @override
  Future<List<CustomerModel>> updateBulkCustomers(UpdateCustomerParam updateCustomerParam) async {
    final response = await apiConsumer.put(EndPoints.updateCustomers,
        body: updateCustomerParam.toJson());

    return List<CustomerModel>.from(
        response.map((x) => CustomerModel.fromJson(x)));
  }

  @override
  Future<CustomerModel> updateCustomerFullName(UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam) async {
    final response = await apiConsumer.put(EndPoints.updateCustomerFullName,
        body: updateCustomerNameOrDescParam.toJson());

    return CustomerModel.fromJson(response);
  }

  @override
  Future<List<CustomerModel>> findDistinctCustomersByPhoneNumber(PhoneNumberModel phoneNumberModel) async {
    final response = await apiConsumer.get(EndPoints.duplicateCustomersByPhoneNo,
        queryParameters: phoneNumberModel.toJson());

    return List<CustomerModel>.from(
        response.map((x) => CustomerModel.fromJson(x)));
  }

  @override
  Future<CustomerModel> updateCustomerDescription(UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam) async {
    final response = await apiConsumer.put(EndPoints.updateCustomerDescription,
        body: updateCustomerNameOrDescParam.toJson());

    return CustomerModel.fromJson(response);
  }

  @override
  Future<CustomerModel> updateCustomerSources(UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) async {
    final response = await apiConsumer.put(EndPoints.updateCustomerSources,
        body: updateCustomerSourcesOrUnitTypesParam.toJson());

    return CustomerModel.fromJson(response);
  }

  @override
  Future<CustomerModel> updateCustomerUnitTypes(UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) async {
    final response = await apiConsumer.put(EndPoints.updateCustomerUnitTypes,
        body: updateCustomerSourcesOrUnitTypesParam.toJson());

    return CustomerModel.fromJson(response);
  }

  @override
  Future<CustomerModel> deleteCustomerAssignedEmployee(DeleteCustomerAssignedEmployeeParam deleteCustomerAssignedEmployeeParam) async {
    final response = await apiConsumer.put(EndPoints.deleteCustomerAssignedEmployee,
        body: deleteCustomerAssignedEmployeeParam.toJson());

    return CustomerModel.fromJson(response);
  }

  @override
  Future<CustomerModel> updateCustomerAssignedEmployee(UpdateCustomerAssignedEmployeeParam updateCustomerAssignedEmployeeParam) async {
    final response = await apiConsumer.put(EndPoints.updateCustomerAssignedEmployee,
        body: updateCustomerAssignedEmployeeParam.toJson());

    return CustomerModel.fromJson(response);
  }


}