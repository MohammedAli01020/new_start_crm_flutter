import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/use_cases/developer_use_case.dart';
import '../models/developer_model.dart';

abstract class DeveloperRemoteDataSource {
  Future<List<DeveloperModel>> getAllDevelopersByNameLike({String? name});

  Future<DeveloperModel> modifyDeveloper(
      ModifyDeveloperParam  modifyDeveloperParam);

  Future<void> deleteDeveloper(int developerId);
}

class DeveloperRemoteDataSourceImpl implements DeveloperRemoteDataSource {
  final ApiConsumer apiConsumer;

  DeveloperRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteDeveloper(int developerId) async {
    return await apiConsumer.delete(EndPoints.deleteDeveloper + developerId.toString());
  }

  @override
  Future<List<DeveloperModel>> getAllDevelopersByNameLike({String? name}) async {
    final response = await apiConsumer
        .get(EndPoints.allDevelopers, queryParameters: {"name": name});

    return List<DeveloperModel>.from(response.map((x) => DeveloperModel.fromJson(x)));
  }

  @override
  Future<DeveloperModel> modifyDeveloper(ModifyDeveloperParam modifyDeveloperParam) async {
    final response = await apiConsumer.post(EndPoints.modifyDeveloper,
        body: modifyDeveloperParam.toJson());

    return DeveloperModel.fromJson(response);
  }

}