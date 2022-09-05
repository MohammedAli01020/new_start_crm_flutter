import 'package:crm_flutter_project/features/employees/data/models/employee_filters_model.dart';
import 'package:crm_flutter_project/features/employees/domain/entities/employees_data.dart';
import 'package:crm_flutter_project/features/employees/domain/use_cases/employee_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';
import '../../data/models/employee_model.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeUseCases employeeUseCases;

  EmployeeCubit({required this.employeeUseCases}) : super(EmployeeInitial());

  static EmployeeCubit get(context) => BlocProvider.of(context);

  EmployeeFiltersModel employeeFiltersModel = EmployeeFiltersModel.initial();

  void updateFilter(EmployeeFiltersModel newFilter) {
    emit(StartUpdateFilter());
    employeeFiltersModel = newFilter;
    emit(EndUpdateFilter());
  }

  void resetFilter() {
    emit(StartResetFilter());
    employeeFiltersModel = EmployeeFiltersModel.initial();
    emit(EndResetFilter());
  }

  List<EmployeeModel> employees = [];
  int employeeCurrentPage = 0;
  int employeeTotalElements = 0;
  late int employeePagesCount;

  bool isNoMoreData = false;

  Future<void> fetchEmployees({bool refresh = false}) async {
    if (state is StartRefreshEmployees || state is StartLoadingEmployees) {
      return;
    }
    if (refresh) {
      employeeCurrentPage = 0;
      isNoMoreData = false;
      emit(StartRefreshEmployees());
    } else {
      if (employeeCurrentPage >= employeePagesCount) {
        isNoMoreData = true;
        emit(LoadNoMoreEmployees());
        return;
      } else {
        emit(StartLoadingEmployees());
      }
    }

    Either<Failure, EmployeesData> response =
        await employeeUseCases.getAllEmployeesWithFilters(employeeFiltersModel
            .copyWith(pageNumber: Wrapped.value(employeeCurrentPage)));

    if (response.isRight()) {
      setEmployeesData(
          result: response.getOrElse(() => throw Exception()),
          refresh: refresh);
    }

    if (refresh) {
      emit(response.fold(
          (failure) =>
              RefreshEmployeesError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndRefreshEmployees()));
    } else {
      emit(response.fold(
          (failure) =>
              LoadingEmployeesError(msg: Constants.mapFailureToMsg(failure)),
          (realestatesData) => EndLoadingEmployees()));
    }
  }

  void setEmployeesData(
      {required EmployeesData result, required bool refresh}) {
    List<EmployeeModel> newEmployees = result.employees;

    employeeCurrentPage++;
    employeeTotalElements = result.totalElements;
    employeePagesCount = result.totalPages;
    if (refresh) {
      employees = newEmployees;
    } else {
      employees.addAll(newEmployees);
    }
  }

  Future<void> deleteEmployee(int employeeId) async {
    emit(StartDeleteEmployee());

    Either<Failure, void> response =
        await employeeUseCases.deleteEmployee(employeeId);

    response.fold(
        (failure) =>
            emit(DeleteEmployeeError(msg: Constants.mapFailureToMsg(failure))),
        (success) {
      try {
        employees.removeWhere((element) {
          return element.employeeId == employeeId;
        });

        employeeTotalElements--;
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndDeleteEmployee(employeeId: employeeId));
    });
  }

  Future<void> modifyEmployee(ModifyEmployeeParam modifyEmployeeParam) async {
    emit(StartModifyEmployee());
    Either<Failure, EmployeeModel> response =
        await employeeUseCases.modifyEmployee(modifyEmployeeParam);

    response.fold(
        (failure) =>
            emit(ModifyEmployeeError(msg: Constants.mapFailureToMsg(failure))),
        (newLoanModel) {
      if (modifyEmployeeParam.employeeId != null) {
        try {
          int index = employees.indexWhere((element) {
            return element.employeeId == modifyEmployeeParam.employeeId;
          });

          employees[index] = newLoanModel;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        employees.insert(0, newLoanModel);
        employeeTotalElements++;
      }

      return emit(EndModifyEmployee(employeeModel: newLoanModel));
    });
  }
}
