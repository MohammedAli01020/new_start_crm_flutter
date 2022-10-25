import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/pre_defined_roles/domain/use_cases/pre_defined_roles_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/constants.dart';
import '../../../employees/data/models/permission_model.dart';
part 'pre_defined_roles_state.dart';

class PreDefinedRolesCubit extends Cubit<PreDefinedRolesState> {
  final PreDefinedRolesUseCases preDefinedRolesUseCases;
  PreDefinedRolesCubit({required this.preDefinedRolesUseCases}) : super(PreDefinedRolesInitial());


  static PreDefinedRolesCubit get(context) => BlocProvider.of(context);

  List<RoleModel> predefinedRoles = [];

  Future<void> getAllPreDefinedRoles() async {
    emit(StartGetAllPreDefinedRoles());

    Either<Failure, List<RoleModel>> response =
    await preDefinedRolesUseCases.getAllPreDefinedRoles();

    response.fold(
            (failure) => emit(GetAllPreDefinedRolesError(
            msg: Constants.mapFailureToMsg(failure))), (fetchedRoles) {
      predefinedRoles = fetchedRoles;
      return emit(EndGetAllPreDefinedRoles(fetchedRoles: fetchedRoles));
    });
  }


  Future<void> modifyPreDefinedRole(ModifyRoleParam modifyRoleParam) async {

    emit(StartModifyPredefinedRole());

    Either<Failure, RoleModel> response =
    await preDefinedRolesUseCases.modifyPreDefinedRole(modifyRoleParam);

    response.fold(
            (failure) => emit(ModifyPredefinedRoleError(
            msg: Constants.mapFailureToMsg(failure))), (modifiedRole) {

      if (modifyRoleParam.roleId != null) {
        try {
          int index = predefinedRoles.indexWhere((element) {
            return element.roleId == modifyRoleParam.roleId;
          });

          predefinedRoles[index] = modifiedRole;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        predefinedRoles.insert(0, modifiedRole);
      }

      return emit(EndModifyPredefinedRole(predefinedRole: modifiedRole));
    });

  }


  List<int> currentDeleting = [];

  Future<void> deletePreDefinedRole(int preDefinedRoleId) async {
    currentDeleting.add(preDefinedRoleId);
    emit(StartDeletePredefinedRole());

    Either<Failure, void> response =
    await preDefinedRolesUseCases.deletePreDefinedRole(preDefinedRoleId);

    currentDeleting.remove(preDefinedRoleId);

    response.fold((failure) => emit(DeletePredefinedRoleError(msg: Constants.mapFailureToMsg(failure))),
            (success) {

          try {
            predefinedRoles.removeWhere((element) {
              return element.roleId == preDefinedRoleId;
            });
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndDeletePredefinedRole(predefinedRoleId: preDefinedRoleId));
        });
  }



  List<PermissionModel> selectedPermissions = [];

  void updateSelectedPermissions(PermissionModel permission) {
    emit(StartUpdateSelectedPermissionsRole());
    if (selectedPermissions.contains(permission)) {
      selectedPermissions.remove(permission);
    } else {
      selectedPermissions.add(permission);
    }
    emit(EndUpdateSelectedPermissionsRole());
  }

  void updateAllPermissions(List<PermissionModel> permissions) {
    emit(StartUpdateSelectedPermissionsRole());

    selectedPermissions = permissions;

    emit(EndUpdateSelectedPermissionsRole());

  }
}
