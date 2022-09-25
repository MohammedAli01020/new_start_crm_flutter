import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel(
      {required int projectId, required String name, required int developer})
      : super(projectId: projectId, name: name, developer: developer);

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        projectId: json["projectId"],
        name: json["name"],
        developer: json["developer"],
      );

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "name": name,
        "developer": developer,
      };
}
