import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/project_model.dart';
import '../use_cases/projects_use_case.dart';
abstract class ProjectRepository {

  Future<Either<Failure, List<ProjectModel>>> getAllProjectsWithFilters(ProjectFilters projectFilters);

  Future<Either<Failure, ProjectModel>> modifyProject(
      ModifyProjectParam modifyProjectParam);

  Future<Either<Failure, void>> deleteProject(int projectId);
}