
import 'package:crm_flutter_project/core/api/end_points.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../employees/data/models/permission_model.dart';


abstract class PermissionRemoteDataPermission {
  Future<List<PermissionModel>> getAllPermissionsByNameLike({String? name});
}

class PermissionRemoteDataPermissionImpl implements PermissionRemoteDataPermission {
  final ApiConsumer apiConsumer;

  PermissionRemoteDataPermissionImpl({required this.apiConsumer});



  @override
  Future<List<PermissionModel>> getAllPermissionsByNameLike({String? name}) async {
    final response = await apiConsumer
        .get(EndPoints.allPermissions, queryParameters: {"name": name});

    return List<PermissionModel>.from(response.map((x) => PermissionModel.fromJson(x)));
  }


}