import 'package:crm_flutter_project/features/customer_table_config/data/models/customer_table_config_model.dart';
import 'package:crm_flutter_project/features/customers/data/models/create_action_request_model.dart';
import 'package:crm_flutter_project/features/customers/data/models/customer_filters_model.dart';
import 'package:crm_flutter_project/features/customers/domain/repositories/customer_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/customer_model.dart';
import '../entities/customers_data.dart';

abstract class CustomerUseCases {
  Future<Either<Failure, CustomersData>> getPageCustomersWithFilters(
      CustomerFiltersModel customerFiltersModel);

  Future<Either<Failure, List<CustomerModel>>> getAllCustomersWithFilters(
      CustomerFiltersModel customerFiltersModel);



  Future<Either<Failure, CustomerModel>> modifyCustomer(
      ModifyCustomerParam modifyCustomerParam);

  Future<Either<Failure, void>> deleteCustomer(int customerId);

  Future<Either<Failure, List<CustomerModel>>> updateBulkCustomers(
      UpdateCustomerParam updateCustomerParam);

  Future<Either<Failure, void>> deleteAllCustomersByIds(CustomerIdsWrapper customerIdsWrapper);


  Future<Either<Failure, CustomerModel>> updateCustomerLastAction(
      UpdateCustomerLastActionParam updateCustomerLastActionParam);


  Future<Either<Failure, CustomerModel>> updateCustomerFullName(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam);

  Future<Either<Failure, CustomerModel>> updateCustomerDescription(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam);

  Future<Either<Failure, List<CustomerModel>>> findDistinctCustomersByPhoneNumbers(
      PhoneNumbersWrapper phoneNumbersWrapper);


  Future<Either<Failure, CustomerModel>> updateCustomerSources(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam);


  Future<Either<Failure, CustomerModel>> updateCustomerUnitTypes(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam);


  Future<Either<Failure, CustomerModel>> updateCustomerAssignedEmployee(
      UpdateCustomerAssignedEmployeeParam updateCustomerAssignedEmployeeParam);

  Future<Either<Failure, CustomerModel>> deleteCustomerAssignedEmployee(
      DeleteCustomerAssignedEmployeeParam deleteCustomerAssignedEmployeeParam);


  Future<Either<Failure, CustomerModel>> updateCustomerPhoneNumber(
      UpdateCustomerPhoneNumberParam updateCustomerPhoneNumberParam);


  Future<Either<Failure, CustomerModel>> updateCustomerDevelopersAndProjects(
      UpdateCustomerDevelopersAndProjectsParam updateCustomerDevelopersAndProjectsParam);

  Future<Either<Failure, void>> cacheCustomerTableConfig(
      CustomerTableConfigModel customerTableConfigModel);


}

class CustomerUseCasesImpl implements CustomerUseCases {
  final CustomerRepository customerRepository;

  CustomerUseCasesImpl({required this.customerRepository});

  @override
  Future<Either<Failure, void>> deleteCustomer(int customerId) {
    return customerRepository.deleteCustomer(customerId);
  }

  @override
  Future<Either<Failure, CustomerModel>> modifyCustomer(
      ModifyCustomerParam modifyCustomerParam) {
    return customerRepository.modifyCustomer(modifyCustomerParam);
  }


  @override
  Future<Either<Failure, List<CustomerModel>>> getAllCustomersWithFilters(
      CustomerFiltersModel customerFiltersModel) {
    return customerRepository.getAllCustomersWithFilters(customerFiltersModel);
  }


  @override
  Future<Either<Failure, CustomersData>> getPageCustomersWithFilters(
      CustomerFiltersModel customerFiltersModel) {
    return customerRepository.getPageCustomersWithFilters(customerFiltersModel);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerLastAction(
      UpdateCustomerLastActionParam updateCustomerLastActionParam) {
    return customerRepository
        .updateCustomerLastAction(updateCustomerLastActionParam);
  }

  @override
  Future<Either<Failure, List<CustomerModel>>> updateBulkCustomers(
      UpdateCustomerParam updateCustomerParam) {
    return customerRepository.updateBulkCustomers(updateCustomerParam);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerFullName(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam) {
    return customerRepository.updateCustomerFullName(
        updateCustomerNameOrDescParam);
  }

  @override
  Future<
      Either<Failure, List<CustomerModel>>> findDistinctCustomersByPhoneNumbers(
      PhoneNumbersWrapper phoneNumbersWrapper) {
    return customerRepository.findDistinctCustomersByPhoneNumber(
        phoneNumbersWrapper);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerDescription(
      UpdateCustomerNameOrDescParam updateCustomerNameOrDescParam) {
    return customerRepository.updateCustomerDescription(
        updateCustomerNameOrDescParam);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerSources(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) {
    return customerRepository.updateCustomerSources(
        updateCustomerSourcesOrUnitTypesParam);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerUnitTypes(
      UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) {
    return customerRepository.updateCustomerUnitTypes(
        updateCustomerSourcesOrUnitTypesParam);
  }

  @override
  Future<Either<Failure, CustomerModel>> deleteCustomerAssignedEmployee(
      DeleteCustomerAssignedEmployeeParam deleteCustomerAssignedEmployeeParam) {
    return customerRepository.deleteCustomerAssignedEmployee(
        deleteCustomerAssignedEmployeeParam);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerAssignedEmployee(
      UpdateCustomerAssignedEmployeeParam updateCustomerAssignedEmployeeParam) {
    return customerRepository.updateCustomerAssignedEmployee(
        updateCustomerAssignedEmployeeParam);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerPhoneNumber(
      UpdateCustomerPhoneNumberParam updateCustomerPhoneNumberParam) {
    return customerRepository.updateCustomerPhoneNumber(
        updateCustomerPhoneNumberParam);
  }

  @override
  Future<Either<Failure, void>> cacheCustomerTableConfig(
      CustomerTableConfigModel customerTableConfigModel) {
    return customerRepository.cacheCustomerTableConfig(
        customerTableConfigModel);
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomerDevelopersAndProjects(
      UpdateCustomerDevelopersAndProjectsParam updateCustomerDevelopersAndProjectsParam) {
    return customerRepository.updateCustomerDevelopersAndProjects(
        updateCustomerDevelopersAndProjectsParam);
  }

  @override
  Future<Either<Failure, void>> deleteAllCustomersByIds(customerIdsWrapper) {
    return customerRepository.deleteAllCustomersByIds(customerIdsWrapper);
  }


}

class ModifyCustomerParam {
  final int? customerId;
  final String fullName;

  final List<String> phoneNumbers;
  final int createDateTime;
  final String? description;
  final List<String> projects;

  final List<String> developers;
  final List<String> unitTypes;
  final List<String> sources;
  final int? createdByEmployeeId;
  final CreateActionRequestModel? createActionRequest;

  final int? assignedEmployeeId;
  final int? assignedByEmployeeId;
  final int? assignedDateTime;

  final int? logByEmployeeId;


  final bool? viewPreviousLog;

  ModifyCustomerParam({
    required this.customerId,
    required this.fullName,
    required this.phoneNumbers,
    required this.createDateTime,
    required this.description,
    required this.projects,
    required this.developers,
    required this.unitTypes,
    required this.sources,
    required this.createdByEmployeeId,
    required this.createActionRequest,
    required this.assignedEmployeeId,
    required this.assignedByEmployeeId,
    required this.assignedDateTime,
    required this.logByEmployeeId,

    required this.viewPreviousLog,


  });

  Map<String, dynamic> toJson() =>
      {
        "customerId": customerId,
        "fullName": fullName,
        "phoneNumbers": phoneNumbers,
        "createDateTime": createDateTime,
        "description": description,

        "projects": projects,
        "developers": developers,

        "unitTypes": unitTypes,
        "sources": sources,
        "createdByEmployeeId": createdByEmployeeId,
        "createActionRequest": createActionRequest?.toJson(),
        "assignedEmployeeId": assignedEmployeeId,
        "assignedByEmployeeId": assignedByEmployeeId,
        "assignedDateTime": assignedDateTime,
        "logByEmployeeId": logByEmployeeId,

        "viewPreviousLog": viewPreviousLog,


      };
}

class UpdateCustomerLastActionParam {
  final int customerId;
  final int dateTime;
  final int? postponeDateTime;
  final int eventId;
  final int lastActionByEmployeeId;
  final String? actionDescription;

  UpdateCustomerLastActionParam({required this.customerId,
    required this.dateTime,
    required this.postponeDateTime,
    required this.eventId,
    required this.lastActionByEmployeeId,
    required this.actionDescription});

  Map<String, dynamic> toJson() =>
      {
        "customerId": customerId,
        "dateTime": dateTime,
        "postponeDateTime": postponeDateTime,
        "eventId": eventId,
        "lastActionByEmployeeId": lastActionByEmployeeId,
        "actionDescription": actionDescription,
      };
}

class UpdateCustomerParam {
  final int? assignedByEmployeeId;

  final int? assignedToEmployeeId;


  final List<String>? sources;

  final List<String>? unitTypes;

  final List<int> customerIds;



  final bool? viewPreviousLog;


  UpdateCustomerParam({
    required this.assignedByEmployeeId,
    required this.assignedToEmployeeId,

    required this.sources,
    required this.unitTypes,
    required this.customerIds,

    required this.viewPreviousLog,


  });

  Map<String, dynamic> toJson() =>
      {
        "assignedByEmployeeId": assignedByEmployeeId,
        "assignedToEmployeeId": assignedToEmployeeId,
        "sources": sources,
        "unitTypes": unitTypes,
        "customerIds": customerIds,
        "viewPreviousLog": viewPreviousLog,
      };
}

class UpdateCustomerNameOrDescParam {
  final int updatedByEmployeeId;

  final int customerId;

  final String updatedFullNameOrDesc;

  UpdateCustomerNameOrDescParam({
    required this.updatedByEmployeeId,
    required this.customerId,
    required this.updatedFullNameOrDesc});


  Map<String, dynamic> toJson() =>
      {
        "updatedByEmployeeId": updatedByEmployeeId,
        "customerId": customerId,
        "updatedFullNameOrDesc": updatedFullNameOrDesc
      };
}

class UpdateCustomerSourcesOrUnitTypesParam {
  final int updatedByEmployeeId;

  final int customerId;

  final List<String> updatedData;

  UpdateCustomerSourcesOrUnitTypesParam({
    required this.updatedByEmployeeId,
    required this.customerId,
    required this.updatedData});


  Map<String, dynamic> toJson() =>
      {
        "updatedByEmployeeId": updatedByEmployeeId,
        "customerId": customerId,
        "updatedData": updatedData
      };
}

class UpdateCustomerAssignedEmployeeParam {
  final int updatedByEmployeeId;

  final int customerId;

  final int assignedEmployee;

  UpdateCustomerAssignedEmployeeParam({
    required this.updatedByEmployeeId,
    required this.customerId,
    required this.assignedEmployee});


  Map<String, dynamic> toJson() =>
      {
        "updatedByEmployeeId": updatedByEmployeeId,
        "customerId": customerId,
        "assignedEmployee": assignedEmployee
      };
}

class DeleteCustomerAssignedEmployeeParam {
  final int updatedByEmployeeId;

  final int customerId;


  DeleteCustomerAssignedEmployeeParam({
    required this.updatedByEmployeeId,
    required this.customerId});


  Map<String, dynamic> toJson() =>
      {
        "updatedByEmployeeId": updatedByEmployeeId,
        "customerId": customerId
      };
}


class UpdateCustomerPhoneNumberParam {
  final int updatedByEmployeeId;

  final int customerId;

  final List<String> phoneNumbers;

  UpdateCustomerPhoneNumberParam({
    required this.updatedByEmployeeId,
    required this.customerId,
    required this.phoneNumbers});


  Map<String, dynamic> toJson() =>
      {
        "updatedByEmployeeId": updatedByEmployeeId,
        "customerId": customerId,
        "phoneNumbers": phoneNumbers
      };
}


class UpdateCustomerDevelopersAndProjectsParam {
  final int updatedByEmployeeId;

  final int customerId;

  final List<String> updatedDevelopers;

  final List<String> updatedProjects;


  UpdateCustomerDevelopersAndProjectsParam({
    required this.updatedByEmployeeId,
    required this.customerId,
    required this.updatedDevelopers,
    required this.updatedProjects

  });


  Map<String, dynamic> toJson() =>
      {
        "updatedByEmployeeId": updatedByEmployeeId,
        "customerId": customerId,
        "updatedDevelopers": updatedDevelopers,
        "updatedProjects": updatedProjects
      };
}


class PhoneNumbersWrapper extends Equatable {
  final List<String> phoneNumbers;

  const PhoneNumbersWrapper({required this.phoneNumbers});


  Map<String, dynamic> toJson() =>
      {
        "phoneNumbers": phoneNumbers,
      };

  @override
  List<Object> get props => [phoneNumbers];
}

class CustomerIdsWrapper extends Equatable {

  final List<int> customerIds;
  final int employeeId;

  const CustomerIdsWrapper({required this.customerIds, required this.employeeId, });


  Map<String, dynamic> toJson() =>
      {
        "customerIds": customerIds,
        "employeeId": employeeId
      };
  @override
  List<Object> get props => [customerIds, employeeId];
}


