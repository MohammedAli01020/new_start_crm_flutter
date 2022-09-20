

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../domain/use_cases/global_reports_use_cases.dart';
import '../models/employee_assigns_report_model.dart';

abstract class GlobalReportsRemoteDataSource {
  Future<List<EmployeeAssignsReportModel>> fetchEmployeesAssignReport(FetchEmployeesAssignReportParam fetchEmployeesAssignReportParam);
}

class GlobalReportsRemoteDataSourceImpl implements GlobalReportsRemoteDataSource {

  final ApiConsumer apiConsumer;

  GlobalReportsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<EmployeeAssignsReportModel>> fetchEmployeesAssignReport(FetchEmployeesAssignReportParam fetchEmployeesAssignReportParam) async {
    final response = await apiConsumer.get(EndPoints.allEmployeeAssignsReports,
        queryParameters: fetchEmployeesAssignReportParam.toJson());

    return List<EmployeeAssignsReportModel>.from(response.map((x) => EmployeeAssignsReportModel.fromJson(x)));
  }
}