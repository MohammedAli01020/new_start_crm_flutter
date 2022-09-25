import '../../domain/entities/developer.dart';

class DeveloperModel extends Developer {
  const DeveloperModel({required int developerId, required String name})
      : super(developerId: developerId, name: name);

  factory DeveloperModel.fromJson(Map<String, dynamic> json) => DeveloperModel(
        developerId: json["developerId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "developerId": developerId,
        "name": name,
      };
}
