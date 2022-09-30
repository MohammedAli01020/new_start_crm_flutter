import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/pre_defined_roles/domain/repositories/pre_defined_roles_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

abstract class PreDefinedRolesUseCases {

  Future<Either<Failure, List<RoleModel>>> getAllPreDefinedRoles();

  Future<Either<Failure, RoleModel>> modifyPreDefinedRole(
      ModifyRoleParam modifyRoleParam);

  Future<Either<Failure, void>> deletePreDefinedRole(int preDefinedRoleId);
}


class PreDefinedRolesUseCasesImpl implements PreDefinedRolesUseCases {
  final PreDefinedRolesRepository preDefinedRolesRepository;

  PreDefinedRolesUseCasesImpl({required this.preDefinedRolesRepository});

  @override
  Future<Either<Failure, void>> deletePreDefinedRole(int preDefinedRoleId) {
    return preDefinedRolesRepository.deletePreDefinedRole(preDefinedRoleId);
  }

  @override
  Future<Either<Failure, List<RoleModel>>> getAllPreDefinedRoles() {
    return preDefinedRolesRepository.getAllPreDefinedRoles();
  }

  @override
  Future<Either<Failure, RoleModel>> modifyPreDefinedRole(ModifyRoleParam modifyRoleParam) {
    return preDefinedRolesRepository.modifyPreDefinedRole(modifyRoleParam);
  }

}


class ModifyRoleParam extends Equatable {

  final int? roleId;

  final String name;

  final List<int> permissionsIds;

  const ModifyRoleParam(
      {required this.roleId, required this.name, required this.permissionsIds});


  Map<String, dynamic> toJson() => {
    "roleId": roleId,
    "name": name,
    "permissionsIds": permissionsIds,
  };

  @override
  List<Object?> get props => [roleId, name, permissionsIds];
}