import 'package:crm_flutter_project/features/employees/data/models/employees_data_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/use_cases/employee_use_cases.dart';
import '../models/employee_filters_model.dart';
import '../models/employee_model.dart';
import '../models/role_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<EmployeesDataModel> getAllEmployeesWithFilters(
      EmployeeFiltersModel employeeFiltersModel);

  Future<EmployeeModel> modifyEmployee(ModifyEmployeeParam modifyEmployeeParam);

  Future<void> deleteEmployee(int costId);

  Future<RoleModel> findRoleByEmployeeId(int employeeId);

  Future<EmployeeModel> getEmployeeById(int employeeId);

}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final ApiConsumer apiConsumer;

  EmployeeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> deleteEmployee(int employeeId) async {
    return await apiConsumer.delete(
      EndPoints.deleteEmployee + employeeId.toString(),
    );
  }

  @override
  Future<EmployeesDataModel> getAllEmployeesWithFilters(
      EmployeeFiltersModel employeeFiltersModel) async {

    final response = await apiConsumer.get(EndPoints.pageEmployee,
        queryParameters: employeeFiltersModel.toJson());

    return EmployeesDataModel.fromJson(response);
  }

  @override
  Future<EmployeeModel> modifyEmployee(
      ModifyEmployeeParam modifyEmployeeParam) async {
    final response = await apiConsumer.post(EndPoints.modifyEmployee,
        body: modifyEmployeeParam.toJson());

    return EmployeeModel.fromJson(response);
  }

  @override
  Future<RoleModel> findRoleByEmployeeId(int employeeId) async {
    final response = await apiConsumer.get(EndPoints.roleByEmployeeId + employeeId.toString());

    return RoleModel.fromJson(response);
  }

  @override
  Future<EmployeeModel> getEmployeeById(int employeeId) async {
    final response = await apiConsumer.get(EndPoints.findEmployeeById + employeeId.toString());

    return EmployeeModel.fromJson(response);
  }

}
