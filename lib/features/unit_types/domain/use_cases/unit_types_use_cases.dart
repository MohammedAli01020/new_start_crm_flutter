import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/unti_type_model.dart';
import '../repositories/unit_types_repository.dart';

abstract class UnitTypesUseCases {
  Future<Either<Failure, List<UnitTypeModel>>> getAllUnitTypesByNameLike(
      {String? name});

  Future<Either<Failure, UnitTypeModel>> modifyUnitType(
      ModifyUnitTypeParam modifyUnitTypeParam);

  Future<Either<Failure, void>> deleteUnitType(int sourceId);
}

class UnitTypesUseCasesImpl implements UnitTypesUseCases {
  final UnitTypesRepository unitTypesRepository;

  UnitTypesUseCasesImpl({required this.unitTypesRepository});

  @override
  Future<Either<Failure, void>> deleteUnitType(int sourceId) {
    return unitTypesRepository.deleteUnitType(sourceId);
  }

  @override
  Future<Either<Failure, List<UnitTypeModel>>> getAllUnitTypesByNameLike(
      {String? name}) {
    return unitTypesRepository.getAllUnitTypesByNameLike(name: name);
  }

  @override
  Future<Either<Failure, UnitTypeModel>> modifyUnitType(
      ModifyUnitTypeParam modifyUnitTypeParam) {
    return unitTypesRepository.modifyUnitType(modifyUnitTypeParam);
  }
}

class ModifyUnitTypeParam extends Equatable {
  final int? unitTypeId;

  final String name;

  const ModifyUnitTypeParam({
    required this.unitTypeId,
    required this.name,
  });

  Map<String, dynamic> toJson() => {"unitTypeId": unitTypeId, "name": name};

  @override
  List<Object?> get props => [unitTypeId, name];
}
