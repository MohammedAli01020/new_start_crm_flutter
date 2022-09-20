import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/unit_types/data/data_sources/unit_type_remote_data_source.dart';
import 'package:crm_flutter_project/features/unit_types/data/models/unti_type_model.dart';
import 'package:crm_flutter_project/features/unit_types/domain/repositories/unit_types_repository.dart';
import 'package:crm_flutter_project/features/unit_types/domain/use_cases/unit_types_use_cases.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';


class UnitTypeRepositoryImpl implements UnitTypesRepository {
  final UnitTypeRemoteDataSource unitTypeRemoteDataUnitType;

  UnitTypeRepositoryImpl({required this.unitTypeRemoteDataUnitType});

  @override
  Future<Either<Failure, void>> deleteUnitType(int unitTypeId) async {
    try {
      final response = await unitTypeRemoteDataUnitType.deleteUnitType(unitTypeId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<UnitTypeModel>>> getAllUnitTypesByNameLike({String? name}) async {
    try {
      final response = await unitTypeRemoteDataUnitType.getAllUnitTypesByNameLike(name: name);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, UnitTypeModel>> modifyUnitType(ModifyUnitTypeParam modifyUnitTypeParam) async {
    try {
      final response = await unitTypeRemoteDataUnitType.modifyUnitType(modifyUnitTypeParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}