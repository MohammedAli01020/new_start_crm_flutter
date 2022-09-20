import 'package:crm_flutter_project/features/unit_types/domain/entities/unit_type.dart';

class UnitTypeModel extends UnitType {
  const UnitTypeModel({required int unitTypeId, required String name})
      : super(unitTypeId: unitTypeId, name: name);

  factory UnitTypeModel.fromJson(Map<String, dynamic> json) => UnitTypeModel(
        unitTypeId: json["unitTypeId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "unitTypeId": unitTypeId,
        "name": name,
      };
}
