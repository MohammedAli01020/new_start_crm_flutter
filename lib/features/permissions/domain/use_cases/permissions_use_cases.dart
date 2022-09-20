
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../employees/data/models/permission_model.dart';
import '../repositories/permission_repository.dart';

abstract class PermissionsUseCases {
  Future<Either<Failure, List<PermissionModel>>> getAllPermissionsByNameLike({String? name});
}

class PermissionsUseCasesImpl implements PermissionsUseCases {
  final PermissionRepository permissionRepository;

  PermissionsUseCasesImpl({required this.permissionRepository});

  @override
  Future<Either<Failure, List<PermissionModel>>> getAllPermissionsByNameLike({String? name}) {
    return permissionRepository.getAllPermissionsByNameLike(name: name);
  }
}


class ModifyPermissionParam extends Equatable {
  final int? permissionId;

  final String name;


  const ModifyPermissionParam({
    required this.permissionId,
    required this.name,
  });

  Map<String, dynamic> toJson() =>
      {
        "permissionId": permissionId,
        "name": name
      };

  @override
  List<Object?> get props => [permissionId, name];
}