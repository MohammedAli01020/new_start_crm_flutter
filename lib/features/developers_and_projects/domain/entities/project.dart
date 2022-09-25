import 'package:equatable/equatable.dart';

class Project extends Equatable {
  const Project({
    required this.projectId,
    required this.name,
    required this.developer,
  });

  final int projectId;
  final String name;
  final int developer;



  @override
  List<Object> get props => [projectId, name, developer];
}
