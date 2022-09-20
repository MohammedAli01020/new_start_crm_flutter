import 'package:crm_flutter_project/core/error/failures.dart';

import 'package:crm_flutter_project/features/employees/data/models/permission_model.dart';
import 'package:crm_flutter_project/features/permissions/data/data_sources/permission_remote_data_source.dart';

import 'package:crm_flutter_project/features/permissions/domain/use_cases/permissions_use_cases.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {

  final PermissionRemoteDataPermission permissionRemoteDataPermission;

  PermissionRepositoryImpl({required this.permissionRemoteDataPermission});

  @override
  Future<Either<Failure, List<PermissionModel>>> getAllPermissionsByNameLike({String? name}) async {
    try {
      final response = await permissionRemoteDataPermission.getAllPermissionsByNameLike(name: name);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }


}