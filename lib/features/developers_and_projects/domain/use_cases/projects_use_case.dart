import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/project_model.dart';
import '../repositories/project_repository.dart';

abstract class ProjectUseCase {
  Future<Either<Failure, List<ProjectModel>>> getAllProjectsWithFilters(
      ProjectFilters projectFilters);

  Future<Either<Failure, ProjectModel>> modifyProject(
      ModifyProjectParam modifyProjectParam);

  Future<Either<Failure, void>> deleteProject(int projectId);
}

class ProjectUseCaseImpl implements ProjectUseCase {
  final ProjectRepository projectRepository;

  ProjectUseCaseImpl({required this.projectRepository});

  @override
  Future<Either<Failure, void>> deleteProject(int projectId) {
    return projectRepository.deleteProject(projectId);
  }

  @override
  Future<Either<Failure, ProjectModel>> modifyProject(
      ModifyProjectParam modifyProjectParam) {
    return projectRepository.modifyProject(modifyProjectParam);
  }

  @override
  Future<Either<Failure, List<ProjectModel>>> getAllProjectsWithFilters(
      ProjectFilters projectFilters) {
    return projectRepository.getAllProjectsWithFilters(projectFilters);
  }
}

class ProjectFilters extends Equatable {
  final String? name;
  final int? developerId;

  const ProjectFilters({this.name, this.developerId});

  Map<String, dynamic> toJson() => {"name": name, "developerId": developerId};

  @override
  List<Object?> get props => [name, developerId];
}

class ModifyProjectParam extends Equatable {
  final int? projectId;
  final String name;
  final int developerId;

  const ModifyProjectParam({
    required this.projectId,
    required this.name,
    required this.developerId,
  });

  Map<String, dynamic> toJson() =>
      {"projectId": projectId, "name": name, "developerId": developerId};

  @override
  List<Object?> get props => [projectId, name, developerId];
}
