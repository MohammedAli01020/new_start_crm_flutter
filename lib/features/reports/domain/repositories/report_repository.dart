import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/report_data_model.dart';
import '../use_cases/report_use_cases.dart';
abstract class ReportRepository {

  Future<Either<Failure, ReportDataModel>> fetchEmployeeCustomerReports(
      FetchEmployeesCustomerReportParam fetchEmployeesCustomerReportParam);
}