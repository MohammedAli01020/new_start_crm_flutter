import 'package:crm_flutter_project/features/permissions/domain/use_cases/permissions_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../employees/data/models/permission_model.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final PermissionsUseCases permissionsUseCases;

  PermissionCubit({required this.permissionsUseCases})
      : super(PermissionInitial());

  static PermissionCubit get(context) => BlocProvider.of(context);

  List<PermissionModel> permissions = [];

  Future<void> getAllPermissionsByNameLike({String? name}) async {

    emit(StartGetAllPermissionsByNameLike());

    Either<Failure, List<PermissionModel>> response =
        await permissionsUseCases.getAllPermissionsByNameLike(name: name);

    response.fold(
        (failure) => emit(GetAllPermissionsByNameLikeError(
            msg: Constants.mapFailureToMsg(failure))), (fetchedPermissions) {
      permissions = fetchedPermissions;
      return emit(EndGetAllPermissionsByNameLike(
          fetchedPermissions: fetchedPermissions));
    });
  }


  List<PermissionModel> selectedPermissions = [];

  void updateSelectedPermissions(PermissionModel permission) {
    emit(StartUpdateSelectedPermissions());
    if (selectedPermissions.contains(permission)) {
      selectedPermissions.remove(permission);
    } else {
      selectedPermissions.add(permission);
    }
    emit(EndUpdateSelectedPermissions());
  }

  void updateAllPermissions(List<PermissionModel> permissions) {
    emit(StartUpdateAllPermissions());

    selectedPermissions = permissions;

    emit(EndUpdateAllPermissions());

  }

}
