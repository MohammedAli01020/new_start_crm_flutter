import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/use_cases/report_use_cases.dart';
import '../models/report_data_model.dart';

abstract class ReportRemoteDataSource {
  Future<ReportDataModel> fetchEmployeeCustomerReports(
      FetchEmployeesCustomerReportParam fetchEmployeesCustomerReportParam);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final ApiConsumer apiConsumer;

  ReportRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ReportDataModel> fetchEmployeeCustomerReports(FetchEmployeesCustomerReportParam fetchEmployeesCustomerReportParam) async {
    final response = await apiConsumer.get(EndPoints.employeeReports,
        queryParameters: fetchEmployeesCustomerReportParam.toJson());

    return ReportDataModel.fromJson(response);
  }

}