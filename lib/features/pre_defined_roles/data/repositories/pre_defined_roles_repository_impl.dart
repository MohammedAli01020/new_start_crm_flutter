import 'package:crm_flutter_project/core/error/failures.dart';

import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/pre_defined_roles/data/data_sources/pre_defined_roles_remote_data_source.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/pre_defined_roles_repository.dart';
import '../../domain/use_cases/pre_defined_roles_use_cases.dart';

class PreDefinedRolesRepositoryImpl implements PreDefinedRolesRepository {
  final PreDefinedRolesRemoteDateSource preDefinedRolesRemoteDateSource;

  PreDefinedRolesRepositoryImpl({required this.preDefinedRolesRemoteDateSource});

  @override
  Future<Either<Failure, void>> deletePreDefinedRole(int preDefinedRoleId) async {
    try {
      final response = await preDefinedRolesRemoteDateSource.deletePreDefinedRole(preDefinedRoleId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<RoleModel>>> getAllPreDefinedRoles() async {
    try {
      final response = await preDefinedRolesRemoteDateSource.getAllPreDefinedRoles();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, RoleModel>> modifyPreDefinedRole(ModifyRoleParam modifyRoleParam) async {
    try {
      final response = await preDefinedRolesRemoteDateSource.modifyPreDefinedRole(modifyRoleParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}