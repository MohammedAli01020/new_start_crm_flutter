import 'package:crm_flutter_project/core/api/end_points.dart';

import '../../../../core/api/api_consumer.dart';
import '../../domain/use_cases/unit_types_use_cases.dart';
import '../models/unti_type_model.dart';

abstract class UnitTypeRemoteDataSource {
  Future<List<UnitTypeModel>> getAllUnitTypesByNameLike({String? name});

  Future<UnitTypeModel> modifyUnitType(ModifyUnitTypeParam modifyUnitTypeParam);

  Future<void> deleteUnitType(int sourceId);
}

class UnitTypeRemoteDataSourceImpl implements UnitTypeRemoteDataSource {
  final ApiConsumer apiConsumer;

  UnitTypeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteUnitType(int sourceId) async {
    return await apiConsumer
        .delete(EndPoints.deleteUnitType + sourceId.toString());
  }

  @override
  Future<List<UnitTypeModel>> getAllUnitTypesByNameLike({String? name}) async {
    final response = await apiConsumer
        .get(EndPoints.allUnitTypes, queryParameters: {"name": name});

    return List<UnitTypeModel>.from(
        response.map((x) => UnitTypeModel.fromJson(x)));
  }

  @override
  Future<UnitTypeModel> modifyUnitType(
      ModifyUnitTypeParam modifyUnitTypeParam) async {
    final response = await apiConsumer.post(EndPoints.modifyUnitType,
        body: modifyUnitTypeParam.toJson());

    return UnitTypeModel.fromJson(response);
  }
}
