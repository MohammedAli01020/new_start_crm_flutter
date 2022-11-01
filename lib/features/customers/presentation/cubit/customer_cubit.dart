import 'package:crm_flutter_project/features/customers/data/models/customer_filters_model.dart';
import 'package:crm_flutter_project/features/customers/domain/entities/customers_data.dart';
import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../customer_table_config/data/models/customer_table_config_model.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../employees/data/models/phoneNumber_model.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/event_model.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerUseCases customerUseCases;

  CustomerCubit({required this.customerUseCases}) : super(CustomerInitial());

  static CustomerCubit get(context) => BlocProvider.of(context);

  CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial();

  void updateFilter(CustomerFiltersModel newFilter) {
    emit(StartUpdateFilter());
    customerFiltersModel = newFilter;
    emit(EndUpdateFilter());
  }

  void resetFilter() {
    emit(StartResetFilter());
    customerFiltersModel = CustomerFiltersModel.initial();
    emit(EndResetFilter());
  }

  void updateCustomers(List<CustomerModel> newCustomers) {
    emit(StartUpdateCustomers());
    customers = newCustomers;
    customerCurrentPage = 0;
    customerTotalElements = 0;
    customerPagesCount = 0;
    emit(EndUpdateCustomers());
  }

  List<CustomerModel> customers = [];

  int customerCurrentPage = 0;

  int customerTotalElements = 0;
  late int customerPagesCount;

  bool isNoMoreData = false;

  Future<void> fetchCustomers({bool refresh = false}) async {
    if (state is StartRefreshCustomers || state is StartLoadingCustomers) {
      return;
    }

    if (refresh) {
      customerCurrentPage = 0;
      isNoMoreData = false;
      emit(StartRefreshCustomers());
    } else {
      if (customerCurrentPage >= customerPagesCount) {
        isNoMoreData = true;
        emit(LoadNoMoreCustomers());
        return;
      } else {
        emit(StartLoadingCustomers());
      }
    }

    Either<Failure, CustomersData> response =
        await customerUseCases.getPageCustomersWithFilters(customerFiltersModel
            .copyWith(pageNumber: Wrapped.value(customerCurrentPage)));

    if (response.isRight()) {
      setCustomersData(
          result: response.getOrElse(() => throw Exception()),
          refresh: refresh);
    }

    if (refresh) {
      emit(response.fold(
          (failure) =>
              RefreshCustomersError(msg: Constants.mapFailureToMsg(failure)),
          (customersData) => EndRefreshCustomers()));
    } else {
      emit(response.fold(
          (failure) =>
              LoadingCustomersError(msg: Constants.mapFailureToMsg(failure)),
          (customersData) => EndLoadingCustomers()));
    }
  }

  void setCustomersData(
      {required CustomersData result, required bool refresh}) {
    List<CustomerModel> newCustomers = result.customers;

    customerCurrentPage++;
    customerTotalElements = result.totalElements;
    customerPagesCount = result.totalPages;
    if (refresh) {
      customers = newCustomers;
    } else {
      customers.addAll(newCustomers);
    }

    if (customerCurrentPage >= customerPagesCount) {
      isNoMoreData = true;
    }
  }



  Future<void> fetchAllCustomers() async {

    emit(StartUpdateSelectedCustomers());

    Either<Failure, List<CustomerModel>> response =
    await customerUseCases.getAllCustomersWithFilters(customerFiltersModel);

    response.fold(
            (failure) => emit(UpdateSelectedCustomersError(msg: Constants.mapFailureToMsg(failure))),
            (newSelectedCustomers) {

              selectedCustomers = newSelectedCustomers;
              return emit(EndUpdateSelectedCustomers(newSelectedCustomers: newSelectedCustomers));
            });

  }

  Future<void> deleteCustomer(int customerId) async {
    emit(StartDeleteCustomer());

    Either<Failure, void> response =
        await customerUseCases.deleteCustomer(customerId);

    response.fold(
        (failure) =>
            emit(DeleteCustomerError(msg: Constants.mapFailureToMsg(failure))),
        (success) {
      try {
        customers.removeWhere((element) {
          return element.customerId == customerId;
        });

        customerTotalElements--;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndDeleteCustomer(customerId: customerId));
    });
  }

  Future<void> modifyCustomer(ModifyCustomerParam modifyCustomerParam) async {
    emit(StartModifyCustomer());
    Either<Failure, CustomerModel> response =
        await customerUseCases.modifyCustomer(modifyCustomerParam);

    response.fold(
        (failure) =>
            emit(ModifyCustomerError(msg: Constants.mapFailureToMsg(failure))),
        (newCustomerModel) {
      if (modifyCustomerParam.customerId != null) {
        try {
          int index = customers.indexWhere((element) {
            return element.customerId == modifyCustomerParam.customerId;
          });

          customers[index] = newCustomerModel;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        customers.insert(0, newCustomerModel);
        customerTotalElements++;
      }

      return emit(EndModifyCustomer(customerModel: newCustomerModel));
    });
  }

  List<CustomerModel> selectedCustomers = [];

  void updateSelectedCustomers(CustomerModel customer, bool val) {
    emit(StartUpdateSelectedCustomers());
    if (val) {
      selectedCustomers.add(customer);
    } else {
      selectedCustomers.remove(customer);
    }

    emit(EndUpdateSelectedCustomers(newSelectedCustomers: selectedCustomers));
  }

  void setSelectedCustomers(List<CustomerModel> newCustomers) {
    emit(StartUpdateSelectedCustomers());
    selectedCustomers = newCustomers;
    emit(EndUpdateSelectedCustomers(newSelectedCustomers: selectedCustomers));
  }

  List<EventModel>? selectedEvents = [];

  void updateSelectedEvents(List<EventModel>? newEvents) {
    emit(StartUpdateEvents());
    selectedEvents = newEvents;
    emit(EndUpdateEvents());
  }


  List<EmployeeModel>? assignEmployees = [];

  void updateSelectedAssignEmployeeIds(List<EmployeeModel>? newAssignEmployees) {
    emit(StartUpdateAssignEmployeeIds());
    assignEmployees = newAssignEmployees;
    emit(EndUpdateAssignEmployeeIds());
  }


  List<EmployeeModel>? createdByEmployees = [];

  void updateSelectedCreatedByEmployeeIds(List<EmployeeModel>? newCreatedByEmployees) {
    emit(StartUpdateCreatedByEmployeeIds());
    createdByEmployees = newCreatedByEmployees;
    emit(EndUpdateCreatedByEmployeeIds());
  }


  List<String>? selectedSources = [];

  void updateSelectedSources(List<String>? newSources) {
    emit(StartUpdateSources());
    selectedSources = newSources;
    emit(EndUpdateSources());
  }

  List<String>? selectedDevelopers = [];

  void updateSelectedDevelopers(List<String>? newDevelopers) {
    emit(StartUpdateDevelopers());
    selectedDevelopers = newDevelopers;
    emit(EndUpdateDevelopers());
  }

  List<String>? selectedProjects = [];

  void updateSelectedProjects(List<String>? newProjects) {
    emit(StartUpdateProjects());
    selectedProjects = newProjects;
    emit(EndUpdateProjects());
  }

  List<String>? selectedUnitTypes = [];

  void updateSelectedUnitTypes(List<String>? newUnitTypes) {
    emit(StartUpdateUnitTypes());
    selectedUnitTypes = newUnitTypes;
    emit(EndUpdateUnitTypes());
  }

  List<int> currentUpdateActions = [];

  Future<void> updateCustomerLastAction(
      UpdateCustomerLastActionParam updateCustomerLastActionParam,
      int index) async {
    currentUpdateActions.add(index);
    emit(StartUpdateCustomerLastAction());

    Either<Failure, CustomerModel> response = await customerUseCases
        .updateCustomerLastAction(updateCustomerLastActionParam);

    currentUpdateActions.remove(index);

    response.fold(
        (failure) => emit(UpdateCustomerLastActionError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId == updateCustomerLastActionParam.customerId;
        });

        customers[index] = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndUpdateCustomerLastAction(customerModel: newCustomerModel));
    });
  }

  Future<void> updateBulkCustomers(
      UpdateCustomerParam updateCustomerParam) async {
    emit(StartUpdateBulkCustomers());

    Either<Failure, List<CustomerModel>> response =
        await customerUseCases.updateBulkCustomers(updateCustomerParam);

    response.fold(
        (failure) => emit(
            UpdateBulkCustomersError(msg: Constants.mapFailureToMsg(failure))),
        (newCustomersModels) {
      for (int i = 0; i < newCustomersModels.length; i++) {
        try {
          int index = customers.indexWhere((element) {
            return element.customerId == newCustomersModels[i].customerId;
          });

          customers[index] = newCustomersModels[i];
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      return emit(EndUpdateBulkCustomers(updatedCustomers: newCustomersModels));
    });
  }

  PhoneNumberModel? phoneNumber;

  void updateCustomerPhoneNumber(PhoneNumberModel? newPhone) {
    emit(StartUpdateCustomerPhoneNumber());
    phoneNumber = newPhone;
    emit(EndUpdateCustomerPhoneNumber());
  }

  late CustomerModel currentCustomer;

  void updateCurrentCustomerModel(CustomerModel updated) {
    emit(StartUpdateCurrentCustomerModel());
    currentCustomer = updated;
    emit(EndUpdateCurrentCustomerModel());
  }

  Future<void> updateCustomerFullName(
      UpdateCustomerNameOrDescParam updateCustomerFullNameParam) async {
    emit(StartUpdateCustomerFullName());
    Either<Failure, CustomerModel> response = await customerUseCases
        .updateCustomerFullName(updateCustomerFullNameParam);

    response.fold(
        (failure) => emit(UpdateCustomerFullNameError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId == updateCustomerFullNameParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndUpdateCustomerFullName(customerModel: newCustomerModel));
    });
  }

  Future<void> updateCustomerDescription(
      UpdateCustomerNameOrDescParam updateCustomerFullNameParam) async {
    emit(StartUpdateCustomerDescription());
    Either<Failure, CustomerModel> response = await customerUseCases
        .updateCustomerDescription(updateCustomerFullNameParam);

    response.fold(
        (failure) => emit(UpdateCustomerDescriptionError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId == updateCustomerFullNameParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(
          EndUpdateCustomerDescription(customerModel: newCustomerModel));
    });
  }

  Future<void> updateCustomerSources(
      UpdateCustomerSourcesOrUnitTypesParam
          updateCustomerSourcesOrUnitTypesParam) async {
    emit(StartUpdateCustomerSources());
    Either<Failure, CustomerModel> response = await customerUseCases
        .updateCustomerSources(updateCustomerSourcesOrUnitTypesParam);

    response.fold(
        (failure) => emit(UpdateCustomerSourcesError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId ==
              updateCustomerSourcesOrUnitTypesParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndUpdateCustomerSources(customerModel: newCustomerModel));
    });
  }

  Future<void> updateCustomerUnitTypes(
      UpdateCustomerSourcesOrUnitTypesParam
          updateCustomerSourcesOrUnitTypesParam) async {
    emit(StartUpdateCustomerUnitTypes());
    Either<Failure, CustomerModel> response = await customerUseCases
        .updateCustomerUnitTypes(updateCustomerSourcesOrUnitTypesParam);

    response.fold(
        (failure) => emit(UpdateCustomerUnitTypesError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId ==
              updateCustomerSourcesOrUnitTypesParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndUpdateCustomerUnitTypes(customerModel: newCustomerModel));
    });
  }

  Future<void> updateCustomerAssignedEmployee(
      UpdateCustomerAssignedEmployeeParam
          updateCustomerAssignedEmployeeParam) async {
    emit(StartUpdateCustomerAssignedEmployee());
    Either<Failure, CustomerModel> response = await customerUseCases
        .updateCustomerAssignedEmployee(updateCustomerAssignedEmployeeParam);

    response.fold(
        (failure) => emit(UpdateCustomerAssignedEmployeeError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId ==
              updateCustomerAssignedEmployeeParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(
          EndUpdateCustomerAssignedEmployee(customerModel: newCustomerModel));
    });
  }

  Future<void> deleteCustomerAssignedEmployee(
      DeleteCustomerAssignedEmployeeParam
          deleteCustomerAssignedEmployeeParam) async {
    emit(StartDeleteCustomerAssignedEmployee());
    Either<Failure, CustomerModel> response = await customerUseCases
        .deleteCustomerAssignedEmployee(deleteCustomerAssignedEmployeeParam);

    response.fold(
        (failure) => emit(DeleteCustomerAssignedEmployeeError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId ==
              deleteCustomerAssignedEmployeeParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(
          EndDeleteCustomerAssignedEmployee(customerModel: newCustomerModel));
    });
  }

  Future<void> updateCustomerPhone(
      UpdateCustomerPhoneNumberParam updateCustomerPhoneNumberParam) async {
    emit(StartUpdateCustomerPhone());
    Either<Failure, CustomerModel> response = await customerUseCases
        .updateCustomerPhoneNumber(updateCustomerPhoneNumberParam);

    response.fold(
        (failure) => emit(
            UpdateCustomerPhoneError(msg: Constants.mapFailureToMsg(failure))),
        (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId ==
              updateCustomerPhoneNumberParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndUpdateCustomerPhone(customerModel: newCustomerModel));
    });
  }

  Future<void> cacheCustomerTableConfig(
      CustomerTableConfigModel customerTableConfigModel) async {
    emit(StartCacheCustomerTableConfig());

    Either<Failure, void> response = await customerUseCases
        .cacheCustomerTableConfig(customerTableConfigModel);

    emit(response.fold(
        (failure) => CacheCustomerTableConfigError(
            msg: Constants.mapFailureToMsg(failure)),
        (r) => EndCacheCustomerTableConfig(
            cachedCustomerTableConfig: customerTableConfigModel)));
  }

  Future<void> updateCustomerDevelopersAndProjects(
      UpdateCustomerDevelopersAndProjectsParam
          updateCustomerDevelopersAndProjectsParam) async {
    emit(StartUpdateCustomerDevelopersAndProjects());
    Either<Failure, CustomerModel> response =
        await customerUseCases.updateCustomerDevelopersAndProjects(
            updateCustomerDevelopersAndProjectsParam);

    response.fold(
        (failure) => emit(UpdateCustomerDevelopersAndProjectsError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomerModel) {
      try {
        int index = customers.indexWhere((element) {
          return element.customerId ==
              updateCustomerDevelopersAndProjectsParam.customerId;
        });
        customers[index] = newCustomerModel;
        currentCustomer = newCustomerModel;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndUpdateCustomerDevelopersAndProjects(
          customerModel: newCustomerModel));
    });
  }

  int currentTablePageIndex = 1;

  void updateTableIndex(int newIndex) {
    currentTablePageIndex = newIndex;
  }

  Future<void> deleteAllCustomersByIds(List<int> customerIds, int employeeId) async {
    emit(StartDeleteAllCustomersByIds());

    Either<Failure, void> response = await customerUseCases
        .deleteAllCustomersByIds(CustomerIdsWrapper(customerIds: customerIds, employeeId: employeeId));

    response.fold(
        (failure) => emit(DeleteAllCustomersByIdsError(
            msg: Constants.mapFailureToMsg(failure))), (v) {


          for (int i = 0; i < customerIds.length; i++) {
            customers.removeWhere((element) {
              return element.customerId == customerIds[i];
            });
          }


      selectedCustomers = [];
      customerTotalElements = customerTotalElements - customerIds.length;

      return emit(EndDeleteAllCustomersByIds());
    });
  }


  bool isAllSelected = false;
  void toggleSelectAll() {
    isAllSelected = !isAllSelected;
  }
}
