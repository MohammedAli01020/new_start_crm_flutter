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
        await customerUseCases.getAllCustomersWithFilters(customerFiltersModel
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
          (realestatesData) => EndRefreshCustomers()));
    } else {
      emit(response.fold(
          (failure) =>
              LoadingCustomersError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndLoadingCustomers()));
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

  List<int> selectedCustomersIds = [];

  void updateSelectedCustomersIds(int teamMemberId, bool val) {
    emit(StartUpdateSelectedCustomers());
    if (val) {
      selectedCustomersIds.add(teamMemberId);
    } else {
      selectedCustomersIds.remove(teamMemberId);
    }

    emit(EndUpdateSelectedCustomers());
  }

  void resetSelectedCustomers() {
    emit(StartResetSelectedCustomers());
    selectedCustomersIds = [];
    emit(EndResetSelectedCustomers());
  }

  List<EventModel>? selectedEvents = [];

  void updateSelectedEvents(List<EventModel>? newEvents) {
    emit(StartUpdateEvents());
    selectedEvents = newEvents;
    emit(EndUpdateEvents());
  }

  List<String>? selectedSources = [];

  void updateSelectedSources(List<String>? newSources) {
    emit(StartUpdateSources());
    selectedSources = newSources;
    emit(EndUpdateSources());
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

  Future<void> updateBulkCustomers(UpdateCustomerParam updateCustomerParam) async {
    emit(StartUpdateBulkCustomers());

    Either<Failure, List<CustomerModel>> response = await customerUseCases
        .updateBulkCustomers(updateCustomerParam);

    response.fold(
            (failure) => emit(UpdateBulkCustomersError(
            msg: Constants.mapFailureToMsg(failure))), (newCustomersModels) {


            for(int i = 0 ; i < newCustomersModels.length ; i ++) {

              try {
                int index = customers.indexWhere((element) {
                  return element.customerId == newCustomersModels[i].customerId;
                });

                customers[index] = newCustomersModels[i];
              } catch(e) {
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


  Future<void> updateCustomerFullName(UpdateCustomerNameOrDescParam updateCustomerFullNameParam) async {
    emit(StartUpdateCustomerFullName());
    Either<Failure, CustomerModel> response =
        await customerUseCases.updateCustomerFullName(updateCustomerFullNameParam);

    response.fold(
            (failure) =>
            emit(UpdateCustomerFullNameError(msg: Constants.mapFailureToMsg(failure))),
            (newCustomerModel) {

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


  Future<void> updateCustomerDescription(UpdateCustomerNameOrDescParam updateCustomerFullNameParam) async {
    emit(StartUpdateCustomerDescription());
    Either<Failure, CustomerModel> response =
    await customerUseCases.updateCustomerDescription(updateCustomerFullNameParam);

    response.fold(
            (failure) =>
            emit(UpdateCustomerDescriptionError(msg: Constants.mapFailureToMsg(failure))),
            (newCustomerModel) {

          try {
            int index = customers.indexWhere((element) {
              return element.customerId == updateCustomerFullNameParam.customerId;
            });
            customers[index] = newCustomerModel;
            currentCustomer = newCustomerModel;
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndUpdateCustomerDescription(customerModel: newCustomerModel));
        });
  }


  Future<void> updateCustomerSources(UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) async {

    emit(StartUpdateCustomerSources());
    Either<Failure, CustomerModel> response =
    await customerUseCases.updateCustomerSources(updateCustomerSourcesOrUnitTypesParam);

    response.fold(
            (failure) =>
            emit(UpdateCustomerSourcesError(msg: Constants.mapFailureToMsg(failure))),
            (newCustomerModel) {

          try {
            int index = customers.indexWhere((element) {
              return element.customerId == updateCustomerSourcesOrUnitTypesParam.customerId;
            });
            customers[index] = newCustomerModel;
            currentCustomer = newCustomerModel;
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndUpdateCustomerSources(customerModel: newCustomerModel));
        });
  }


  Future<void> updateCustomerUnitTypes(UpdateCustomerSourcesOrUnitTypesParam updateCustomerSourcesOrUnitTypesParam) async {

    emit(StartUpdateCustomerUnitTypes());
    Either<Failure, CustomerModel> response =
    await customerUseCases.updateCustomerUnitTypes(updateCustomerSourcesOrUnitTypesParam);

    response.fold(
            (failure) =>
            emit(UpdateCustomerUnitTypesError(msg: Constants.mapFailureToMsg(failure))),
            (newCustomerModel) {

          try {
            int index = customers.indexWhere((element) {
              return element.customerId == updateCustomerSourcesOrUnitTypesParam.customerId;
            });
            customers[index] = newCustomerModel;
            currentCustomer = newCustomerModel;
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndUpdateCustomerUnitTypes(customerModel: newCustomerModel));
        });
  }




  Future<void> updateCustomerAssignedEmployee(UpdateCustomerAssignedEmployeeParam updateCustomerAssignedEmployeeParam) async {

    emit(StartUpdateCustomerAssignedEmployee());
    Either<Failure, CustomerModel> response =
    await customerUseCases.updateCustomerAssignedEmployee(updateCustomerAssignedEmployeeParam);

    response.fold(
            (failure) =>
            emit(UpdateCustomerAssignedEmployeeError(msg: Constants.mapFailureToMsg(failure))),
            (newCustomerModel) {

          try {
            int index = customers.indexWhere((element) {
              return element.customerId == updateCustomerAssignedEmployeeParam.customerId;
            });
            customers[index] = newCustomerModel;
            currentCustomer = newCustomerModel;
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndUpdateCustomerAssignedEmployee(customerModel: newCustomerModel));
        });
  }



  Future<void> deleteCustomerAssignedEmployee(DeleteCustomerAssignedEmployeeParam deleteCustomerAssignedEmployeeParam) async {

    emit(StartDeleteCustomerAssignedEmployee());
    Either<Failure, CustomerModel> response =
    await customerUseCases.deleteCustomerAssignedEmployee(deleteCustomerAssignedEmployeeParam);

    response.fold(
            (failure) =>
            emit(DeleteCustomerAssignedEmployeeError(msg: Constants.mapFailureToMsg(failure))),
            (newCustomerModel) {

          try {
            int index = customers.indexWhere((element) {
              return element.customerId == deleteCustomerAssignedEmployeeParam.customerId;
            });
            customers[index] = newCustomerModel;
            currentCustomer = newCustomerModel;
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndDeleteCustomerAssignedEmployee(customerModel: newCustomerModel));
        });
  }

}
