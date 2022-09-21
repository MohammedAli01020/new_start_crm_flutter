import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../employees/domain/entities/employee.dart';
import '../../domain/entities/current_employee.dart';
import '../../domain/use_cases/login_use_cases.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCases loginUseCases;

  LoginCubit({required this.loginUseCases}) : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  Future<void> login(LoginParam loginParam) async {
    emit(StartLogin());
    Either<Failure, CurrentEmployee> response =
        await loginUseCases.login(loginParam);

    response.fold(
        (failure) => emit(LoginError(msg: Constants.mapFailureToMsg(failure))),
        (currentEmployee) {
      return emit(EndLogin(currentEmployee: currentEmployee));
    });
  }

  Future<void> logout() async {
    emit(StartLogout());
    Either<Failure, void> response = await loginUseCases.logout();
    emit(response.fold(
        (failure) => LoginError(msg: Constants.mapFailureToMsg(failure)),
        (success) => EndLogout()));
  }

  Future<void> init() async {

    emit(StartInit());
    Either<Failure, CurrentEmployee> response =
        await loginUseCases.getSavedCurrentEmployee();

    response.fold(
        (failure) => emit(
            NoCachedEmployeeFound(msg: Constants.mapFailureToMsg(failure))),
        (currentEmployee) async {

      Constants.currentEmployee = currentEmployee;

      Either<Failure, Employee> response =
          await loginUseCases.getEmployeeById(currentEmployee.employeeId);
      response.fold(
          (failure) {
            loginUseCases.logout();
           return emit(GettingEmployeeError(msg: Constants.mapFailureToMsg(failure)));
          },
          (newEmployee) {
        if (!newEmployee.enabled) {
          return emit(
              EmployeeIsNotEnabled(msg: AppStrings.userNotEnabledMessage));
        }

        List<String> permissions = [];

        if (newEmployee.role != null && newEmployee.role!.permissions.isNotEmpty) {
          permissions.addAll(newEmployee.role!.permissions.map((e) => e.name));
        }

        Constants.currentEmployee = Constants.currentEmployee!.copyWith(
          enabled: Wrapped.value(newEmployee.enabled),
          username: Wrapped.value(newEmployee.username),
          fullName: Wrapped.value(newEmployee.fullName),
          createDateTime: Wrapped.value(newEmployee.createDateTime),
          permissions: Wrapped.value(permissions),
          teamId: Wrapped.value(newEmployee.team),
        );

        return emit(EndInit());
      });
    });
  }



  Future<void> updateCurrentUser() async {

    emit(StartGettingEmployee());

    Either<Failure, Employee> response =
        await loginUseCases.getEmployeeById(Constants.currentEmployee!.employeeId);

    response.fold(
            (failure) => emit(
            GettingEmployeeError(msg: Constants.mapFailureToMsg(failure))),
    (newEmployee) {
      if (!newEmployee.enabled) {
        return emit(
            EmployeeIsNotEnabled(msg: AppStrings.userNotEnabledMessage));
      }

      // start fetch permissions by role id
      List<String> permissions = [];

      if (newEmployee.role != null && newEmployee.role!.permissions.isNotEmpty) {
        permissions.addAll(newEmployee.role!.permissions.map((e) => e.name));
      }

      Constants.currentEmployee = Constants.currentEmployee!.copyWith(
        enabled: Wrapped.value(newEmployee.enabled),
        username: Wrapped.value(newEmployee.username),
        fullName: Wrapped.value(newEmployee.fullName),
        createDateTime: Wrapped.value(newEmployee.createDateTime),
        permissions: Wrapped.value(permissions),
        teamId: Wrapped.value(newEmployee.team),
      );

      return emit(EndGettingEmployee());
    });
  }

}
