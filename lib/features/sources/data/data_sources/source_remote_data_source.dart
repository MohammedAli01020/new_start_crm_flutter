
import 'package:crm_flutter_project/core/api/end_points.dart';

import '../../../../core/api/api_consumer.dart';
import '../../domain/use_cases/sources_use_cases.dart';
import '../models/source_model.dart';

abstract class SourceRemoteDataSource {
  Future<List<SourceModel>> getAllSourcesByNameLike({String? name});

  Future<SourceModel> modifySource(
      ModifySourceParam modifySourceParam);

  Future<void> deleteSource(int sourceId);
}

class SourceRemoteDataSourceImpl implements SourceRemoteDataSource {
  final ApiConsumer apiConsumer;

  SourceRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteSource(int sourceId) async {
    return await apiConsumer.delete(EndPoints.deleteSource + sourceId.toString());
  }

  @override
  Future<List<SourceModel>> getAllSourcesByNameLike({String? name}) async {
    final response = await apiConsumer
        .get(EndPoints.allSources, queryParameters: {"name": name});

    return List<SourceModel>.from(response.map((x) => SourceModel.fromJson(x)));
  }

  @override
  Future<SourceModel> modifySource(ModifySourceParam modifySourceParam) async {
    final response = await apiConsumer.post(EndPoints.modifySource,
        body: modifySourceParam.toJson());

    return SourceModel.fromJson(response);
  }

}