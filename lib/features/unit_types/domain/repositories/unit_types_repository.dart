import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/unti_type_model.dart';
import '../use_cases/unit_types_use_cases.dart';

abstract class UnitTypesRepository {
  Future<Either<Failure, List<UnitTypeModel>>> getAllUnitTypesByNameLike(
      {String? name});

  Future<Either<Failure, UnitTypeModel>> modifyUnitType(
      ModifyUnitTypeParam modifyUnitTypeParam);

  Future<Either<Failure, void>> deleteUnitType(int sourceId);
}
