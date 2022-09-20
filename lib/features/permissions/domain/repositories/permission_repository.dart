import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../employees/data/models/permission_model.dart';

abstract class PermissionRepository {
  Future<Either<Failure, List<PermissionModel>>> getAllPermissionsByNameLike({String? name});
}