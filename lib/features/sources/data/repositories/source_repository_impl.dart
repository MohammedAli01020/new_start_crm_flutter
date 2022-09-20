import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/sources/data/data_sources/source_remote_data_source.dart';

import 'package:crm_flutter_project/features/sources/data/models/source_model.dart';

import 'package:crm_flutter_project/features/sources/domain/use_cases/sources_use_cases.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/source_repository.dart';

class SourceRepositoryImpl implements SourceRepository {
  final SourceRemoteDataSource sourceRemoteDataSource;

  SourceRepositoryImpl({required this.sourceRemoteDataSource});
  @override
  Future<Either<Failure, void>> deleteSource(int sourceId) async {
    try {
      final response = await sourceRemoteDataSource.deleteSource(sourceId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<SourceModel>>> getAllSourcesByNameLike({String? name}) async {
    try {
      final response = await sourceRemoteDataSource.getAllSourcesByNameLike(name: name);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, SourceModel>> modifySource(ModifySourceParam modifySourceParam) async {
    try {
      final response = await sourceRemoteDataSource.modifySource(modifySourceParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}