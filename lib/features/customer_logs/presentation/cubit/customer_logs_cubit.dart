import 'package:crm_flutter_project/features/customer_logs/data/models/customer_log_filters_model.dart';
import 'package:crm_flutter_project/features/customer_logs/domain/entities/customer_logs_data.dart';
import 'package:crm_flutter_project/features/customer_logs/domain/use_cases/customer_log_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';
import '../../data/models/customer_log_model.dart';

part 'customer_logs_state.dart';

class CustomerLogsCubit extends Cubit<CustomerLogsState> {
  final CustomerLogUseCases customerLogUseCases;

  CustomerLogsCubit({required this.customerLogUseCases})
      : super(CustomerLogsInitial());

  static CustomerLogsCubit get(context) => BlocProvider.of(context);

  CustomerLogFiltersModel customerLogFiltersModel = CustomerLogFiltersModel.initial();

  void updateFilter(CustomerLogFiltersModel newFilter) {
    emit(StartUpdateFilter());
    customerLogFiltersModel = newFilter;
    emit(EndUpdateFilter());
  }

  void resetFilter() {
    emit(StartResetFilter());
    customerLogFiltersModel = CustomerLogFiltersModel.initial();
    emit(EndResetFilter());
  }

  List<CustomerLogModel> customerLogs = [];
  int customerLogCurrentPage = 0;
  int customerLogTotalElements = 0;
  late int customerLogPagesCount;

  bool isNoMoreData = false;

  void setCurrentPage(int index) {
    emit(StartChangeCurrentPage());
    customerLogCurrentPage = index;
    emit(EndChangeCurrentPage());
  }


  void resetData() {
    emit(StartResetData());

     customerLogs = [];
     customerLogCurrentPage = 0;
     customerLogTotalElements = 0;
     isNoMoreData = false;

    emit(EndResetData());

  }

  Future<void> fetchCustomerLogs(
      {bool refresh = false, required bool isWebPagination}) async {
    if (state is StartRefreshCustomerLogs ||
        state is StartLoadingCustomerLogs) {
      return;
    }

    if (refresh && isWebPagination) {
      isNoMoreData = false;
      emit(StartRefreshCustomerLogs());
    }

    if (refresh && !isWebPagination) {
      customerLogCurrentPage = 0;
      isNoMoreData = false;
      emit(StartRefreshCustomerLogs());
    } else if (!isWebPagination) {
      if (customerLogCurrentPage >= customerLogPagesCount) {
        isNoMoreData = true;
        emit(LoadNoMoreCustomerLogs());
        return;
      } else {
        emit(StartLoadingCustomerLogs());
      }
    }

    Either<Failure, CustomerLogsData> response =
        await customerLogUseCases.getAllCustomerLogsWithFilters(customerLogFiltersModel
            .copyWith(pageNumber: Wrapped.value(customerLogCurrentPage)));

    if (response.isRight()) {
      setCustomerLogsData(
          result: response.getOrElse(() => throw Exception()),
          refresh: refresh,
          isWebPagination: isWebPagination);
    }

    if (refresh) {
      emit(response.fold(
          (failure) =>
              RefreshCustomerLogsError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndRefreshCustomerLogs()));
    } else {
      emit(response.fold(
          (failure) =>
              LoadingCustomerLogsError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndLoadingCustomerLogs()));
    }
  }

  void setCustomerLogsData(
      {required CustomerLogsData result,
      required bool refresh,
      required bool isWebPagination}) {
    List<CustomerLogModel> newCustomerLogs = result.customerLogs;

    if (!isWebPagination) {
      customerLogCurrentPage++;
    }

    customerLogTotalElements = result.totalElements;
    customerLogPagesCount = result.totalPages;
    if (refresh) {
      customerLogs = newCustomerLogs;
    } else {
      customerLogs.addAll(newCustomerLogs);
    }
  }
}
