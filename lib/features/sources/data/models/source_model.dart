
import '../../domain/entities/source.dart';

class SourceModel extends Source {
  const SourceModel({required int sourceId, required String name}) : super(sourceId: sourceId, name: name);


  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      SourceModel(
        sourceId: json["sourceId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() =>
      {
        "sourceId": sourceId,
        "name": name,
      };
}