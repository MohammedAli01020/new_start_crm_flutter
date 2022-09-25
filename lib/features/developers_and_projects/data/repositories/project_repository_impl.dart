import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/features/developers_and_projects/data/data_sources/project_remote_data_source.dart';

import 'package:crm_flutter_project/features/developers_and_projects/data/models/project_model.dart';

import 'package:crm_flutter_project/features/developers_and_projects/domain/use_cases/projects_use_case.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource projectRemoteDataSource;

  ProjectRepositoryImpl({required this.projectRemoteDataSource});
  @override
  Future<Either<Failure, void>> deleteProject(int projectId) async {
    try {
      final response = await projectRemoteDataSource.deleteProject(projectId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<ProjectModel>>> getAllProjectsWithFilters(ProjectFilters projectFilters) async {
    try {
      final response = await projectRemoteDataSource.getAllProjectsWithFilters(projectFilters);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, ProjectModel>> modifyProject(ModifyProjectParam modifyProjectParam) async {
    try {
      final response = await projectRemoteDataSource.modifyProject(modifyProjectParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }
  
}