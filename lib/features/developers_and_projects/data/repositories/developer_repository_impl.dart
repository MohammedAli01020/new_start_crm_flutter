import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/developers_and_projects/data/data_sources/developer_remote_data_source.dart';

import 'package:crm_flutter_project/features/developers_and_projects/data/models/developer_model.dart';

import 'package:crm_flutter_project/features/developers_and_projects/domain/use_cases/developer_use_case.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/developer_repository.dart';

class DeveloperRepositoryImpl implements DeveloperRepository {
  final DeveloperRemoteDataSource developerRemoteDataSource;

  DeveloperRepositoryImpl({required this.developerRemoteDataSource});

  @override
  Future<Either<Failure, void>> deleteDeveloper(int developerId) async {
    try {
      final response = await developerRemoteDataSource.deleteDeveloper(developerId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<DeveloperModel>>> getAllDevelopersByNameLike({String? name}) async {
    try {
      final response = await developerRemoteDataSource.getAllDevelopersByNameLike(name: name);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, DeveloperModel>> modifyDeveloper(ModifyDeveloperParam modifyDeveloperParam) async {
    try {
      final response = await developerRemoteDataSource.modifyDeveloper(modifyDeveloperParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }
  
}