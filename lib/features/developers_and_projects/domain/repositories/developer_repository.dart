import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/developer_model.dart';
import '../use_cases/developer_use_case.dart';

abstract class DeveloperRepository {
  Future<Either<Failure, List<DeveloperModel>>> getAllDevelopersByNameLike({String? name});

  Future<Either<Failure, DeveloperModel>> modifyDeveloper(
      ModifyDeveloperParam  modifyDeveloperParam);

  Future<Either<Failure, void>> deleteDeveloper(int developerId);
}