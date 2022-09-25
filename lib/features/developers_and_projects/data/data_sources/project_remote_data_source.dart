import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/use_cases/projects_use_case.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getAllProjectsWithFilters(ProjectFilters projectFilters);

  Future<ProjectModel> modifyProject(
      ModifyProjectParam  modifyProjectParam);

  Future<void> deleteProject(int developerId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProjectRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteProject(int developerId) async {
    return await apiConsumer.delete(EndPoints.deleteProject + developerId.toString());
  }


  @override
  Future<ProjectModel> modifyProject(ModifyProjectParam modifyProjectParam) async {
    final response = await apiConsumer.post(EndPoints.modifyProject,
        body: modifyProjectParam.toJson());

    return ProjectModel.fromJson(response);
  }

  @override
  Future<List<ProjectModel>> getAllProjectsWithFilters(ProjectFilters projectFilters) async {
    final response = await apiConsumer.get(EndPoints.allProjects,
        queryParameters: projectFilters.toJson());

    return List<ProjectModel>.from(response.map((x) => ProjectModel.fromJson(x)));
  }

}