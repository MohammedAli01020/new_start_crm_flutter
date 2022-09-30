import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../employees/data/models/role_model.dart';
import '../use_cases/pre_defined_roles_use_cases.dart';

abstract class PreDefinedRolesRepository {
  Future<Either<Failure, List<RoleModel>>> getAllPreDefinedRoles();

  Future<Either<Failure, RoleModel>> modifyPreDefinedRole(
      ModifyRoleParam modifyRoleParam);

  Future<Either<Failure, void>> deletePreDefinedRole(int preDefinedRoleId);
}