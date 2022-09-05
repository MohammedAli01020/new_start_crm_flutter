import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../domain/use_cases/login_use_cases.dart';
import '../models/current_employee_model.dart';

abstract class LoginRemoteDataSource {
  Future<CurrentEmployeeModel> login(LoginParam loginParam);
  Future<EmployeeModel> getEmployeeById(int employerId);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiConsumer apiConsumer;

  LoginRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<CurrentEmployeeModel> login(LoginParam loginParam) async {
    final response =
        await apiConsumer.post(EndPoints.login, body: loginParam.toJson());

    return CurrentEmployeeModel.fromJson(response);
  }

  @override
  Future<EmployeeModel> getEmployeeById(int employerId) async {
    final response =
        await apiConsumer.get(EndPoints.findEmployeeById + employerId.toString());

    return EmployeeModel.fromJson(response);
  }
}
