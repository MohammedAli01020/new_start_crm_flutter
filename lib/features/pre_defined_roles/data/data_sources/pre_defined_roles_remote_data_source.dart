import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../employees/data/models/role_model.dart';
import '../../domain/use_cases/pre_defined_roles_use_cases.dart';

abstract class PreDefinedRolesRemoteDateSource {
  Future<List<RoleModel>> getAllPreDefinedRoles();

  Future<RoleModel> modifyPreDefinedRole(ModifyRoleParam modifyRoleParam);

  Future<void> deletePreDefinedRole(int preDefinedRoleId);
}

class PreDefinedRolesRemoteDateSourceImpl
    implements PreDefinedRolesRemoteDateSource {
  final ApiConsumer apiConsumer;

  PreDefinedRolesRemoteDateSourceImpl({required this.apiConsumer});

  @override
  Future<void> deletePreDefinedRole(int preDefinedRoleId) async {
    return await apiConsumer
        .delete(EndPoints.deletePreDefinedRole + preDefinedRoleId.toString());
  }

  @override
  Future<List<RoleModel>> getAllPreDefinedRoles() async {
    final response = await apiConsumer.get(EndPoints.allPreDefinedRoles);

    return List<RoleModel>.from(response.map((x) => RoleModel.fromJson(x)));
  }

  @override
  Future<RoleModel> modifyPreDefinedRole(ModifyRoleParam modifyRoleParam) async {
    final response = await apiConsumer.post(EndPoints.modifyPreDefinedRole,
        body: modifyRoleParam.toJson());

    return RoleModel.fromJson(response);
  }
}
