import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/entities/employee_statistics_result.dart';
import '../models/count_customer_type_filters_model.dart';

abstract class OwnReportsRemoteDataSource {
  Future<EmployeeStatisticsResult> fetchEmployeeReports(
      CountCustomerTypeFiltersModel countCustomerTypeFiltersModel);
}

class OwnReportsRemoteDataSourceImpl implements OwnReportsRemoteDataSource {
  final ApiConsumer apiConsumer;

  OwnReportsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<EmployeeStatisticsResult> fetchEmployeeReports(CountCustomerTypeFiltersModel countCustomerTypeFiltersModel) async {
    final response = await apiConsumer.get(EndPoints.employeeOwnReports,
        queryParameters: countCustomerTypeFiltersModel.toJson());

    return EmployeeStatisticsResult.fromJson(response);
  }



}