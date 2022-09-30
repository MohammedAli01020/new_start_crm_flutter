part of 'customer_cubit.dart';

@immutable
abstract class CustomerState extends Equatable {
  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}


class StartUpdateFilter extends CustomerState {}

class EndUpdateFilter extends CustomerState {}

class StartResetFilter extends CustomerState {}

class EndResetFilter extends CustomerState {}

class StartRefreshCustomers extends CustomerState {}

class EndRefreshCustomers extends CustomerState {}

class RefreshCustomersError extends CustomerState {
  final String msg;

  RefreshCustomersError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartLoadingCustomers extends CustomerState {}

class EndLoadingCustomers extends CustomerState {}

class LoadingCustomersError extends CustomerState {
  final String msg;

  LoadingCustomersError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class LoadNoMoreCustomers extends CustomerState {}

// modify

class StartModifyCustomer extends CustomerState {}

class EndModifyCustomer extends CustomerState {
  final CustomerModel customerModel;

  EndModifyCustomer({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class ModifyCustomerError extends CustomerState {
  final String msg;

  ModifyCustomerError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteCustomer extends CustomerState {}

class EndDeleteCustomer extends CustomerState {
  final int customerId;

  EndDeleteCustomer({required this.customerId});

  @override
  List<Object> get props => [customerId];
}

class DeleteCustomerError extends CustomerState {
  final String msg;

  DeleteCustomerError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateSelectedCustomers extends CustomerState {}

class EndUpdateSelectedCustomers extends CustomerState {}


class StartSetSelectedCustomers extends CustomerState {}

class EndSetSelectedCustomers extends CustomerState {}

// events
class StartUpdateEvents extends CustomerState {}

class EndUpdateEvents extends CustomerState {}

// sources
class StartUpdateSources extends CustomerState {}

class EndUpdateSources extends CustomerState {}


// developers
class StartUpdateDevelopers extends CustomerState {}

class EndUpdateDevelopers extends CustomerState {}


// projects
class StartUpdateProjects extends CustomerState {}

class EndUpdateProjects extends CustomerState {}


// unitTypes
class StartUpdateUnitTypes extends CustomerState {}

class EndUpdateUnitTypes extends CustomerState {}

// last action
class StartUpdateCustomerLastAction extends CustomerState {}

class EndUpdateCustomerLastAction extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerLastAction({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerLastActionError extends CustomerState {
  final String msg;

  UpdateCustomerLastActionError({required this.msg});

  @override
  List<Object> get props => [msg];
}

// bulk update customers

class StartUpdateBulkCustomers extends CustomerState {}

class EndUpdateBulkCustomers extends CustomerState {
  final List<CustomerModel> updatedCustomers;

  EndUpdateBulkCustomers({required this.updatedCustomers});

  @override
  List<Object> get props => [updatedCustomers];
}

class UpdateBulkCustomersError extends CustomerState {
  final String msg;

  UpdateBulkCustomersError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class StartUpdateCustomerPhoneNumber extends CustomerState {}

class EndUpdateCustomerPhoneNumber extends CustomerState {}


class StartUpdateCurrentCustomerModel extends CustomerState {}

class EndUpdateCurrentCustomerModel extends CustomerState {}


class StartUpdateCustomerFullName extends CustomerState {}

class EndUpdateCustomerFullName extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerFullName({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerFullNameError extends CustomerState {
  final String msg;

  UpdateCustomerFullNameError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateCustomerDescription extends CustomerState {}

class EndUpdateCustomerDescription extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerDescription({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerDescriptionError extends CustomerState {
  final String msg;

  UpdateCustomerDescriptionError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateCustomerSources extends CustomerState {}

class EndUpdateCustomerSources extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerSources({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerSourcesError extends CustomerState {
  final String msg;

  UpdateCustomerSourcesError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateCustomerUnitTypes extends CustomerState {}

class EndUpdateCustomerUnitTypes extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerUnitTypes({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerUnitTypesError extends CustomerState {
  final String msg;

  UpdateCustomerUnitTypesError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateCustomerAssignedEmployee extends CustomerState {}

class EndUpdateCustomerAssignedEmployee extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerAssignedEmployee({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerAssignedEmployeeError extends CustomerState {
  final String msg;

  UpdateCustomerAssignedEmployeeError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteCustomerAssignedEmployee extends CustomerState {}

class EndDeleteCustomerAssignedEmployee extends CustomerState {
  final CustomerModel customerModel;

  EndDeleteCustomerAssignedEmployee({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class DeleteCustomerAssignedEmployeeError extends CustomerState {
  final String msg;

  DeleteCustomerAssignedEmployeeError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateCustomerPhone extends CustomerState {}

class EndUpdateCustomerPhone extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerPhone({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerPhoneError extends CustomerState {
  final String msg;

  UpdateCustomerPhoneError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateCustomerDevelopersAndProjects extends CustomerState {}

class EndUpdateCustomerDevelopersAndProjects extends CustomerState {
  final CustomerModel customerModel;

  EndUpdateCustomerDevelopersAndProjects({required this.customerModel});

  @override
  List<Object> get props => [customerModel];
}

class UpdateCustomerDevelopersAndProjectsError extends CustomerState {
  final String msg;

  UpdateCustomerDevelopersAndProjectsError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartUpdateCustomers extends CustomerState {}

class EndUpdateCustomers extends CustomerState {}


class StartCacheCustomerTableConfig extends CustomerState {}

class EndCacheCustomerTableConfig extends CustomerState {
  final CustomerTableConfigModel cachedCustomerTableConfig;

  EndCacheCustomerTableConfig({required this.cachedCustomerTableConfig});

  @override
  List<Object> get props => [cachedCustomerTableConfig];
}

class CacheCustomerTableConfigError extends CustomerState {
  final String msg;

  CacheCustomerTableConfigError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartFetchCustomers extends CustomerState {}

class EndFetchCustomers extends CustomerState {
  final CustomersData customersData;

  EndFetchCustomers({required this.customersData});

  @override
  List<Object> get props => [customersData];
}

class FetchCustomersError extends CustomerState {
  final String msg;

  FetchCustomersError({required this.msg});

  @override
  List<Object> get props => [msg];
}


class StartDeleteAllCustomersByIds extends CustomerState  {}
class EndDeleteAllCustomersByIds extends CustomerState  {

}
class DeleteAllCustomersByIdsError extends CustomerState  {
  final String msg;

  DeleteAllCustomersByIdsError({required this.msg});

  @override
  List<Object> get props => [msg];
}
